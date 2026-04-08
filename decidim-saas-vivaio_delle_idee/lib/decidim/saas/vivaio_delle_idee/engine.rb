# frozen_string_literal: true

module Decidim
  module Saas
    module VivaioDelleIdee
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::VivaioDelleIdee

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.vivaio_delle_idee.municipality_region_province" do
          Decidim::ExtraUserFields.configure do |config|
            config.select_fields = {
              municipality_region_province: {
                "milan_lombardy" => "decidim.extra_user_fields.municipality_region_province.milan_lombardy",
                "rome_lazio" => "decidim.extra_user_fields.municipality_region_province.rome_lazio"
              }
            }
          end
        end
      end
    end
  end
end
