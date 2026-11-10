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
                     ENV.fetch("SINERGIA_CRM_CLIENT_SECRET", ""),
                     client_options: {
                       site: ENV.fetch("SINERGIA_CRM_SITE"),
                       authorize_url: ENV.fetch("SINERGIA_CRM_AUTHORIZE_URL", "/oauth/authorize"),
                       token_url: ENV.fetch("SINERGIA_CRM_TOKEN_URL", "/oauth/token")
                     },
                     user_info_url: ENV.fetch("SINERGIA_CRM_USER_INFO_URL", "/oauth/userinfo"),
                     uid_field: ENV.fetch("SINERGIA_CRM_UID_FIELD", "id"),
                     name_field: ENV.fetch("SINERGIA_CRM_NAME_FIELD", "name"),
                     email_field: ENV.fetch("SINERGIA_CRM_EMAIL_FIELD", "email")
          end

          Decidim.omniauth_providers[:sinergia_crm] = { enabled: true }
        end
      end
    end
  end
end
