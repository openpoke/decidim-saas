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

        initializer "saas.ehu_agora.authorizations" do
          Decidim::Verifications.register_workflow(:agora_member) do |auth|
            auth.form = "Decidim::Saas::EhuAgora::AgoraAuthorizationHandler"
            auth.renewable = true
            auth.time_between_renewals = 1.hour
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
                         assertion_consumer_service_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST", # or :post, :redirect
                         request_attributes: [
                           { :name => "email", :name_format => "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", :friendly_name => "Email address" },
                           { :name => "name", :name_format => "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", :friendly_name => "Full name" },
                           { :name => "first_name", :name_format => "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", :friendly_name => "Given name" },
                           { :name => "last_name", :name_format => "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", :friendly_name => "Family name" },
                           { :name => "alias", :name_format => "urn:oasis:names:tc:SAML:2.0:attrname-format:basic", :friendly_name => "Alias" }
                         ],
                         attribute_statements: {
                           name: %w(alias name),
                           email: %w(email mail),
                           first_name: %w(first_name firstname firstName),
                           last_name: %w(last_name lastname lastName),
                           nickname: %w(alias name)
                         }
                       )
            end
            # Register the provider with Decidim's omniauth_providers
            Decidim.omniauth_providers[:saml] = {
              enabled: true,
              icon_path: "media/images/saml_icon.png"
            }
          end
        end

        initializer "saas.ehu_agora.saml_sso_update_user_data" do
          # Update user's extended_data when login
          ActiveSupport::Notifications.subscribe(/decidim\.user\.omniauth_login/) do |_name, data|
            user = Decidim::User.find_by(id: data[:user_id])
            next if user.blank?

            # Change the email if it is different
            if user.email != data[:email]
              previous_email = user.email
              user.email = data[:email]
              user.skip_reconfirmation!
              if user.save
                Rails.logger.info "Email updated from #{previous_email} to #{data[:email]} for user #{user.id}"
              else
                Rails.logger.error "Error updating email from #{previous_email} to #{data[:email]} for user #{user.id}: #{user.errors.full_messages}"
              end
            end

            # Change the name if it is different
            if user.name != data[:name]
              previous_name = user.name
              user.name = data[:name]
              if user.save
                Rails.logger.info "Name updated from #{previous_name} to #{data[:name]} for user #{user.id}"
              else
                Rails.logger.error "Error updating name from #{previous_name} to #{data[:name]} for user #{user.id}: #{user.errors.full_messages}"
              end
            end
          end
        end
      end
    end
  end
end
