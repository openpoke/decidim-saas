# frozen_string_literal: true

# The current open data CSVs export all comments in a list with no particular order.
#
# We need a rake task that generates a CSV with the following fields:
#
#     Id of the participatory space
#     Title of the participatory space
#     Id of the component
#     Name of the component
#     Id of the comment
#     Text of the comment
#     Dates of the comment
#     Any other relevant info about the comment
#
# Other specs:
#
#     Only use the default organization locale for titles/names/description etc.
#     Order the csv by:
#         Participatory space first
#         Component
#         children comments after each parent comment
#         each comment by creation date
#
#
#         ["id", "decidim_commentable_type", "decidim_commentable_id", "decidim_author_id", "created_at", "updated_at", "depth", "alignment", "decidim_user_group_id", "decidim_root_commentable_type", "decidim_root_commentable_id", "decidim_author_type", "body", "comments_count", "decidim_participatory_space_type", "decidim_participatory_space_id", "deleted_at", "up_votes_count", "down_votes_count"]

namespace :saas do
  desc "Export Comments to a CSV"
  task export_comments: :environment do
    export_dir = Rails.root.join("tmp/comments_export")
    FileUtils.mkdir_p export_dir

    organizations = Decidim::Organization.all

    organizations.each do |org|
      export_comments(export_dir, org)
    end
  end

  def export_comments(export_dir, organization)
    path = export_dir.join("#{organization.id}_comments.csv")
    locale = organization.default_locale

    count = 0

    CSV.open(path, "wb") do |csv|
      csv << %w(participatory_space_id participatory_space_name component_id component_title body comment_id created_at updated_at)

      comments = Decidim::Comments::Comment.includes(commentable: :participatory_space).order(:decidim_participatory_space_id, :decidim_commentable_id, :created_at)

      comments.each do |comment|
        component = comment.commentable
        space = comment.commentable&.participatory_space
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

        count += 1
      end

      puts "Exported #{count} comments. You can find them in #{path}"
    end
  end
end
