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

  def export_comments_for_organization(export_dir, organization)
    path = export_dir.join("#{organization.id}_comments.csv")

    CSV.open(path, "wb") do |csv|
      csv << %w(participatory_space_id participatory_space_name component_id component_title body comment_id created_at updated_at)

      comments = Decidim::Comments::Comment.includes(commentable: :participatory_space).where(depth: 0).order(:decidim_participatory_space_id, :decidim_commentable_id, :created_at)
      comments_by_participatory_space = {}

      comments.each do |comment|
        space = comment.commentable&.participatory_space
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
        component = comment.commentable

        component_comments[component.id] ||= []
        component_comments[component.id] << comment
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

  def export_comment_and_children(comment, organization, csv)
    locale = organization.default_locale
    space = comment.commentable&.participatory_space

    component = comment.commentable
    if component.respond_to?(:name)
      name = component.name[locale]
    elsif component.respond_to?(:title)
      name = if component.title.instance_of?(String)
               component.title
             else
               component.title[locale]
             end
    end

    csv << [space.id, space.title[locale], component.id, name, comment.body[locale], comment.id, comment.created_at, comment.updated_at]

    children = Decidim::Comments::Comment.where(decidim_commentable_id: comment.id, decidim_commentable_type: Decidim::Comments::Comment.name).order(:created_at)
    children.each do |child|
      export_comment_and_children(child, organization, csv)
    end
  end
end
