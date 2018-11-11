# frozen_string_literal: true

module Oauth
  module Google
    class CreateUser < ApplicationService
      def initialize(payload:)
        @payload = payload
      end

      def call
        yield user = create_missing_user
        success(data: { user: user })
      end

      private

      attr_reader :payload

      def create_missing_user
        User.create!(
          email: main_email,
          # first_name: payload[:name][:givenName],
          # last_name: payload[:name][:familyName],
          # languages: user_languages,
          password: SecureRandom.hex(20),
          confirmed_at: Time.current
        )
      end
    end
  end
end
