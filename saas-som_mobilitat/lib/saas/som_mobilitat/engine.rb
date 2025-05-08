# frozen_string_literal: true

module Saas
  module SomMobilitat
    class Engine < ::Rails::Engine
      isolate_namespace Saas::SomMobilitat

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      initializer "saas.som_mobilitat.authorizations" do
        Decidim::Verifications.register_workflow(:sommobilitat_member) do |auth|
          auth.form = "Saas::SomMobilitat::MemberAuthorizationHandler"
          auth.renewable = true
          auth.time_between_renewals = 1.hour
        end
      end
    end
  end
end
