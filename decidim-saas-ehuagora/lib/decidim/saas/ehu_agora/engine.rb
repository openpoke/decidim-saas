# frozen_string_literal: true

module Decidim
  module Saas
    module EhuAgora
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::EhuAgora

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil
      end
    end
  end
end
