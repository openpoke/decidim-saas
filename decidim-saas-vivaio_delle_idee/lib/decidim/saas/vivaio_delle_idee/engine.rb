# frozen_string_literal: true

module Decidim
  module Saas
    module VivaioDelleIdee
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::VivaioDelleIdee

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil
      end
    end
  end
end
