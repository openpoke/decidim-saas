# frozen_string_literal: true

namespace :saas do
  desc "Export Comments to a CSV"
  task export_comments: :environment do
    export_dir = Rails.root.join("tmp/comments_export")
    FileUtils.mkdir_p export_dir

    organizations = Decidim::Organization.all

    organizations.each do |org|
      export_comments_for_organization(export_dir, org)
    end
  end

  task :export_comments_by_component_and_dates, [:component, :from, :to] => :environment do |_, args|
    component_id = args[:component].to_i
    from_date = args[:from] ? Time.zone.parse(args[:from]) : nil
    to_date = args[:to] ? Time.zone.parse(args[:to]) : nil

    component = Decidim::Component.find(component_id)
    organization = component.organization

    locale = organization.default_locale
    puts "Exporting comments for organization #{organization.id}-#{organization.name[locale]}"

    export_dir = Rails.root.join("tmp/comments_export_by_component")
    FileUtils.mkdir_p export_dir
    path = export_dir.join("#{organization.id}_component_#{component_id}_comments.csv")

    CSV.open(path, "wb") do |csv|
      csv << %w(participatory_space_id participatory_space_name component_id component_title commentable_id commentable_type commentable_name
                comment_locale comment comment_translated author_id author_name comment_url comment_id
                parent_comment_id created_at updated_at)

      comments = Decidim::Comments::Comment.includes(commentable: :participatory_space).where(depth: 0, created_at: from_date..to_date).order(:created_at)
      comments_to_export = {}
      comments_to_export[component_id] = []

      comments.each do |comment|
        next if comment.commentable.component.nil? || comment.commentable.component.id != component_id

        comments_to_export[component_id] << comment
      end

      export_comments_by_component(comments_to_export, organization, csv)
    end

    puts "Exported comments for component #{component_id} to #{path}"
  rescue ActiveRecord::RecordNotFound
    puts "Component with id #{component_id} not found."
  end

  def export_comments_for_organization(export_dir, organization)
    path = export_dir.join("#{organization.id}_comments.csv")

    locale = organization.default_locale
    puts "Exporting comments for organization #{organization.id}-#{organization.name[locale]}"

    CSV.open(path, "wb") do |csv|
      csv << %w(participatory_space_id participatory_space_name component_id component_title commentable_id commentable_type commentable_name
                comment_locale comment comment_translated author_id author_name comment_url comment_id
                parent_comment_id created_at updated_at)

      comments = Decidim::Comments::Comment.includes(commentable: :participatory_space).where(depth: 0).order(:decidim_participatory_space_id, :decidim_commentable_id, :created_at)
      comments_by_participatory_space = {}

      comments.each do |comment|
        space = comment.commentable&.participatory_space
        next if space.nil? || space.decidim_organization_id != organization.id

        comments_by_participatory_space[space.id] ||= []
        comments_by_participatory_space[space.id] << comment
      end

      export_comments_by_space(comments_by_participatory_space, organization, csv)
    end
  end

  def export_comments_by_space(space_comments, organization, csv)
    space_comments.sort.to_h.each do |_, comments|
      component_comments = {}

      comments.each do |comment|
        next if comment.commentable.nil? || comment.commentable.component.nil?

        component_comments[comment.commentable.component.id] ||= []
        component_comments[comment.commentable.component.id] << comment
      end

      export_comments_by_component(component_comments, organization, csv)
    end
  end

  def export_comments_by_component(component_comments, organization, csv)
    component_comments.sort.to_h.each do |_, comments|
      comments.each do |comment|
        export_comment_and_children(comment, organization, csv)
      end
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def export_comment_and_children(comment, organization, csv)
    locale = organization.default_locale
    space = comment.commentable.participatory_space
    component = comment.commentable.component

    commentable = comment.commentable

    if commentable.respond_to?(:name)
      commentable_name = commentable.name[locale]
    elsif commentable.respond_to?(:title)
      commentable_name = if commentable.title.instance_of?(String)
                           commentable.title
                         else
                           commentable.title[locale]
                         end
    end

    parent_comment = nil
    parent_comment = comment.decidim_commentable_id if comment.decidim_commentable_type == Decidim::Comments::Comment.name

    comment_locale = comment.body.first.first
    body_original = comment.body.first.second
    body_translated = comment.body["machine_translations"]&.[](locale) || body_original
    begin
      url = Decidim::ResourceLocatorPresenter.new(comment.root_commentable).url + "#comment_#{comment.id}"
    rescue StandardError => e
      puts "URL_ERROR: #{e.message} for commentable #{commentable.class.name}##{commentable.id}"
      url = ""
    end
    csv << [space&.id, space&.title&.[](locale), component&.id, component&.name&.[](locale), commentable.id, commentable.class, commentable_name,
            comment_locale, body_original, body_translated, comment.author.id, comment.author.name, url, comment.id, parent_comment, comment.created_at, comment.updated_at]

    children = Decidim::Comments::Comment.where(decidim_commentable_id: comment.id, decidim_commentable_type: Decidim::Comments::Comment.name).order(:created_at)
    children.each do |child|
      export_comment_and_children(child, organization, csv)
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
