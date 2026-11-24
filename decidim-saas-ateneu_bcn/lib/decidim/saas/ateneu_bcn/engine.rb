# frozen_string_literal: true

require "omniauth"
require "omniauth/strategies/sinergia_crm"

module Decidim
  module Saas
    module AteneuBcn
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::AteneuBcn

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.ateneu_bcn.sinergia_crm_sso" do
          next unless ENV["SINERGIA_CRM_SITE"].present? && ENV["SINERGIA_CRM_CLIENT_ID"].present?

          Rails.application.config.middleware.use OmniAuth::Builder do
            provider :sinergia_crm,
                     ENV.fetch("SINERGIA_CRM_CLIENT_ID"),
                     ENV["SINERGIA_CRM_CLIENT_SECRET"].presence,
                     client_options: {
                       site: ENV.fetch("SINERGIA_CRM_SITE"),
                       authorize_url: ENV.fetch("SINERGIA_CRM_AUTHORIZE_URL", "/index.php?entryPoint=sticPortalLogin"),
                       token_url: ENV.fetch("SINERGIA_CRM_TOKEN_URL", "/index.php?entryPoint=sticPortalOAuthToken"),
                       auth_scheme: :request_body
                     }
          end

          Decidim.omniauth_providers[:sinergia_crm] = {
            enabled: true,
            icon_path: "media/images/sinergia_crm_icon.png"
          }
        end
      end
    end
  end
end
