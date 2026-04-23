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
          Decidim.icons.register(name: "chat-1-fill", icon: "chat-1-fill", category: "system", description: "", engine: :core)

          Decidim::ApplicationController.class_eval do
            include Decidim::Saas::VivaioDelleIdee::NeedsSurveyCompleted
          end

          Decidim::ContentBlocks::HeroCell.class_eval do
            def translated_welcome_up_text
              translated_attribute(model.settings.welcome_up_text)
            end
          end

          Decidim::Surveys::SurveysController.class_eval do
            def after_response_path
              if onboarding_assembly_survey?
                decidim_assemblies.assembly_path(Decidim::Assembly.find_by(slug: ENV.fetch("ASSEMBLY_SLUG", nil), organization: current_organization))
              else
                questionnaire_for
              end
            end

            private

            def onboarding_assembly_survey?
              questionnaire_for.component.participatory_space_type == "Decidim::Assembly"
            end
          end

          Decidim::Proposals::ProposalLCell.class_eval do
            private

            def extra_class
              model.official? ? "proposal--official" : "proposal--participant"
            end
          end

          Decidim::Proposals::ProposalGCell.class_eval do
            private

            def classes
              extra = model.official? ? "proposal--official" : "proposal--participant"
              super.merge(
                metadata: "card__list-metadata",
                default: "#{super[:default]} #{extra}"
              )
            end
          end
        end

        initializer "saas.vivaio_delle_idee.static_files" do |app|
          app.middleware.use ActionDispatch::Static, "#{root}/public"
        end

        initializer "saas.vivaio_delle_idee.cell_views" do
          Cell::ViewModel.view_paths.unshift File.expand_path("#{root}/app/cells")
        end

        initializer "saas.vivaio_delle_idee.hero_content_block_settings", after: "decidim.core.content_blocks" do
          Decidim.content_blocks.for(:homepage).find { |cb| cb.name == :hero }&.settings do |settings|
            settings.attribute :welcome_up_text, type: :string, translated: true
            settings.attribute :welcome_down_text, type: :string, translated: true
          end
        end
      end
    end
  end
end
