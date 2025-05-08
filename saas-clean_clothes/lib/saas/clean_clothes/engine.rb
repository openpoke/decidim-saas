# frozen_string_literal: true

require "decidim/extra_user_fields"

module Saas
  module CleanClothes
    class Engine < ::Rails::Engine
      isolate_namespace Saas::CleanClothes

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil
    end
  end
end
