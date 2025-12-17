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
          if ENV["SAML_IDP_METADATA_URL"].present?
            require 'onelogin/ruby-saml/idp_metadata_parser'
            idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
            idp_metadata = idp_metadata_parser.parse_remote_to_hash(
              ENV.fetch("SAML_IDP_METADATA_URL", nil)
            )

            Rails.application.config.middleware.use OmniAuth::Builder do
              provider :saml,
                       idp_metadata.merge(
                        sp_entity_id: ENV.fetch("SAML_SP_ENTITY_ID", nil),
                        name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
                        certificate: "-----BEGIN CERTIFICATE-----\n#{ENV.fetch("SAML_SP_CERTIFICATE", nil)}\n-----END CERTIFICATE-----",
                        private_key: "-----BEGIN PRIVATE KEY-----\n#{ENV.fetch("SAML_SP_PRIVATE_KEY", nil)}\n-----END PRIVATE KEY-----"
                       )
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
