# frozen_string_literal: true

module Decidim
  module Saas
    module SillyCensus
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::SillyCensus

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.silly_census.elections" do
          Decidim::Elections.census_registry.register(:silly_census) do |manifest|
            manifest.voter_form = "Decidim::Saas::SillyCensus::CodeForm"
            manifest.voter_form_partial = "decidim/saas/silly_census/code_form"
            manifest.admin_form = "Decidim::Saas::SillyCensus::AdminCodeForm"
            manifest.admin_form_partial = "decidim/saas/silly_census/admin_code_form"

            manifest.user_query do |election|
              Decidim::Elections::Voter.where(election: election)
            end
            manifest.census_ready_validator do |_election|
              true
            end
          end
        end
      end
    end
  end
end
