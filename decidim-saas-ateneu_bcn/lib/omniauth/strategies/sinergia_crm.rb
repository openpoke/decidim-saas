# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class SinergiaCrm < OmniAuth::Strategies::OAuth2
      option :name, "sinergia_crm"
      option :client_options, {}
      option :authorize_options, [:scope]

      uid { raw_info[options.uid_field.to_sym] || raw_info[options.uid_field] }

      info do
        {
          name: value_for(:name),
          email: value_for(:email),
          first_name: value_for(:first_name),
          last_name: value_for(:last_name)
        }.compact
      end

      extra do
        { raw_info: raw_info }
      end

      option :uid_field, "id"
      option :name_field, "name"
      option :email_field, "email"
      option :first_name_field, "first_name"
      option :last_name_field, "last_name"

      def raw_info
        @raw_info ||= access_token.get(options.user_info_url).parsed
      end

      private

      def value_for(field)
        raw_info[options.public_send("#{field}_field").to_sym] || raw_info[options.public_send("#{field}_field")]
      end
    end
  end
end
