# frozen_string_literal: true

module Decidim
  module Saas
    module SomMobilitat
      # Handles the authorization process for Som Mobilitat members.
      class MemberAuthorizationHandler < Decidim::AuthorizationHandler
        validate :valid_member
        attribute :email, String
        attribute :dni, String

        def form_attributes
          excepted_attributes = %w(id user email)
          excepted_attributes << "tos_agreement" unless ephemeral_tos_pending?
          # only show DNI if email check failed
          # byebug
          # excepted_attributes << "dni" if attributes[:email].blank?
          attributes.except(*excepted_attributes).keys
        end

        def email
          user&.email
        end

        def to_partial_path
          "decidim/saas/som_mobilitat/member_authorization_handler"
        end

        def self.handler_name
          "sommobilitat_member"
        end

        def unique_id
          Digest::MD5.hexdigest(
            "#{uid}-#{Rails.application.secrets.secret_key_base}"
          )
        end

        def uid
          return if api_count.zero?

          api_request.dig("rows", 0, "id")
        end

        def metadata
          super.merge(
            id: uid,
            email: api_request.dig("rows", 0, "email"),
            address: api_request.dig("rows", 0, "address"),
            lang: api_request.dig("rows", 0, "lang"),
            name: api_request.dig("rows", 0, "name")
          )
        end

        private

        def api_count
          api_request["count"].to_i
        rescue StandardError => e
          Rails.logger.error("Error fetching Som Mobilitat member API for email [#{email}]: #{e.message}")
          0
        end

        def api_request
          @api_request ||= begin
            response = Faraday.get(ENV.fetch("SOMMOBILITAT_API_URL", nil)) do |req|
              req.options.timeout = 2
              req.headers["content_type"] = "application/json"
              req.params["member"] = "true"
              if dni.present?
                req.params["vat"] = dni
              else
                req.params["email"] = email
              end
              req.headers["API-KEY"] = ENV.fetch("SOMMOBILITAT_API_KEY", nil)
            end
            JSON.parse(response.body)
          end
        end

        def valid_member
          errors.add(:base, I18n.t("decidim.authorization_handlers.sommobilitat_member.email_not_found")) if uid.blank?
        end
      end
    end
  end
end
