# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class SinergiaCrm < OmniAuth::Strategies::OAuth2
      option :name, "sinergia_crm"
      option :client_options, {}
      option :authorize_options, [:scope]

      # Contact and account UUIDs can overlap, so include the portal type.
      uid { "#{raw_info["portal_type"]}:#{raw_info["portal_id"]}" }

      info do
        {
          email: raw_info.dig("user", "email")
        }.compact
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.params
      end
    end
  end
end
