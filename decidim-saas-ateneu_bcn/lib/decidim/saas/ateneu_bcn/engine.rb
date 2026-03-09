# frozen_string_literal: true

require "omniauth"
require "omniauth-saml"
module Decidim
  module Saas
    module AteneuBcn
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::AteneuBcn

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil
      end
    end
  end
end
