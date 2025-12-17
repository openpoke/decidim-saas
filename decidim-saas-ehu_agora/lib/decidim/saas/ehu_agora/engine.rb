# frozen_string_literal: true

require "omniauth"
require "omniauth-saml"
module Decidim
  module Saas
    module EhuAgora
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Saas::EhuAgora

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        initializer "saas.ehu_agora.saml_sso" do
          if ENV["SAML_IDP_SSO_SERVICE_URL"].present?
            Rails.application.config.middleware.use OmniAuth::Builder do
              provider :saml,
                       sp_entity_id: ENV.fetch("SAML_SP_ENTITY_ID", nil),
                       idp_sso_service_url: ENV.fetch("SAML_IDP_SSO_SERVICE_URL", nil),
                       idp_sso_service_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect",
                       idp_cert: "-----BEGIN CERTIFICATE-----\n#{ENV.fetch("SAML_IDP_CERT", nil)}\n-----END CERTIFICATE-----",
                       name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
                       certificate: "-----BEGIN CERTIFICATE-----\n#{ENV.fetch("SAML_SP_CERTIFICATE", nil)}\n-----END CERTIFICATE-----",
                       private_key: "-----BEGIN PRIVATE KEY-----\n#{ENV.fetch("SAML_SP_PRIVATE_KEY", nil)}\n-----END PRIVATE KEY-----"
            end
            # Force Decidim to look at this provider if not defined in secrets.yml
            Rails.application.secrets[:omniauth][:saml] = {
              enabled: true,
              icon_path: "media/images/saml_icon.png"
            }
          end
        end
      end
    end
  end
end
