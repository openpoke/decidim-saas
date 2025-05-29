# frozen_string_literal: true

require "decidim/extra_user_fields"
require "deface"

module Decidim
  module Saas
    module CleanClothes
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::CleanClothes

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.clean_clothes.age_ranges" do
          Decidim::ExtraUserFields.configure do |config|
            config.age_ranges = %w(30_or_younger 31_or_older prefer_not_to_say)

            config.select_fields = {
              participant_type: {
                "individual" => "decidim.extra_user_fields.participant_types.individual",
                "organization" => "decidim.extra_user_fields.participant_types.organization"
              },
              organization_country: ->(form) { ISO3166::Country.translations(form.locale).invert },
              organization_type: {
                "civil_society" => "decidim.extra_user_fields.organization_types.civil_society",
                "educational" => "decidim.extra_user_fields.organization_types.educational",
                "company" => "decidim.extra_user_fields.organization_types.company",
                "public_administration" => "decidim.extra_user_fields.organization_types.public_administration",
                "other" => "decidim.extra_user_fields.organization_types.other"
              }
            }

            config.boolean_fields = %w(ngo educational_activity)
            config.text_fields = {
              organization_name: false
            }
          end
        end

        initializer "saas.clean_clothes.webpacker.assets_path" do
          Decidim.register_assets_path File.expand_path("app/packs", root)
        end
      end
    end
  end
end
