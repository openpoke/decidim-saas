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

        config.to_prepare do
          Decidim::Devise::OmniauthRegistrationsController.class_eval do
            skip_before_action :verify_authenticity_token, only: [:saml, :failure]
          end
        end

        initializer "saas.ehu_agora.saml_sso" do
          if ENV["SAML_IDP_METADATA_URL"].present?
            require "onelogin/ruby-saml/idp_metadata_parser"
            idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
            idp_metadata = idp_metadata_parser.parse_remote_to_hash(
              ENV.fetch("SAML_IDP_METADATA_URL", nil)
            )

            Rails.application.config.middleware.use OmniAuth::Builder do
              provider :saml,
                       idp_metadata.merge(
                         assertion_consumer_service_url: ENV.fetch("SAML_ASSERTION_CONSUMER_SERVICE_URL", nil),
                         sp_entity_id: ENV.fetch("SAML_SP_ENTITY_ID", nil),
                         name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
                         certificate: "-----BEGIN CERTIFICATE-----\n#{ENV.fetch("SAML_SP_CERTIFICATE", nil)}\n-----END CERTIFICATE-----",
                         private_key: "-----BEGIN PRIVATE KEY-----\n#{ENV.fetch("SAML_SP_PRIVATE_KEY", nil)}\n-----END PRIVATE KEY-----",
                         assertion_consumer_service_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" # or :post, :redirect
                         #  request_attributes: [
                         #    { name: "email", name_format: "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", friendly_name: "Email", is_required: true },
                         #    { name: "name", name_format: "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", friendly_name: "Full Name", is_required: true }
                         #  ]
                       )
            end
            # Register the provider with Decidim's omniauth_providers
            Decidim.omniauth_providers[:saml] = {
              enabled: true,
              icon_path: "media/images/saml_icon.png"
            }
          end
        end
      end
    end
  end
end
