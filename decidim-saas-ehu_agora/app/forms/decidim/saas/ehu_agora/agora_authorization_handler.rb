# frozen_string_literal: true

module Decidim
  module Saas
    module EhuAgora
      # Handles the authorization process for EHU Agora (SAML logins) members.
      class AgoraAuthorizationHandler < Decidim::AuthorizationHandler
        validate :valid_member

        def self.handler_name
          "agora_member"
        end

        def unique_id
          return if uid.blank?

          uid
        end

        def to_partial_path
          "ehu_agora/agora_authorization_handler/form"
        end

        protected

        def identity
          @identity ||= Decidim::Identity.find_by(
            provider: "saml",
            decidim_user_id: user.id
          )
        end

        def uid
          return "forced-#{user.id}" unless identity

          identity.uid
        end

        def valid_member
          errors.add(:user, I18n.t("ehu_agora.verifications.not_agora_member")) if identity.blank?
        end
      end
    end
  end
end
