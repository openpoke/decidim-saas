# frozen_string_literal: true

require "decidim/extra_user_fields"
require "deface"
require "json"

module Decidim
  module Saas
    module VivaioDelleIdee
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::VivaioDelleIdee

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.vivaio_delle_idee.extra_user_fields" do
          Decidim::ExtraUserFields.configure do |config|
            config.select_fields = {
              municipality_region_province: lambda { |_view|
                [] # options loaded client-side via AJAX from /comuni_regioni_province.json
              },
              relationship_with_avs: {
                "registered" => "decidim.extra_user_fields.relationship_with_avs.registered",
                "elected_avs" => "decidim.extra_user_fields.relationship_with_avs.elected_avs",
                "administrator" => "decidim.extra_user_fields.relationship_with_avs.administrator",
                "expert" => "decidim.extra_user_fields.relationship_with_avs.expert",
                "citizen" => "decidim.extra_user_fields.relationship_with_avs.citizen",
                "sympathizer" => "decidim.extra_user_fields.relationship_with_avs.sympathizer"
              },
              territorial_availability: {
                "affirmative_yes" => "decidim.extra_user_fields.territorial_availability.affirmative_yes",
                "negative_no" => "decidim.extra_user_fields.territorial_availability.negative_no",
                "not_specified" => "decidim.extra_user_fields.territorial_availability.not_specified"

              },
              facilitator_or_editor: {
                "facilitator" => "decidim.extra_user_fields.facilitator_or_editor.facilitator",
                "editor" => "decidim.extra_user_fields.facilitator_or_editor.editor"
              },
              priority_themes: lambda { |view|
                view.current_organization.taxonomies
                    .roots
                    .map { |taxonomy| [view.translated_attribute(taxonomy.name), taxonomy.id.to_s] }
              }
            }

            config.text_fields = %w(first_name last_name available_skills organization_or_group)
          end
        end

        config.to_prepare do
          Decidim::RegistrationForm.class_eval do
            private

            def required_collection_fields
              # Fields are completed later when the user fills in their profile
            end
          end

          Decidim::ApplicationController.class_eval do
            include Decidim::Saas::VivaioDelleIdee::NeedsSurveyCompleted
          end
        end

        initializer "saas.vivaio_delle_idee.static_files" do |app|
          app.middleware.use ActionDispatch::Static, "#{root}/public"
        end
      end
    end
  end
end
