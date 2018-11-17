# frozen_string_literal: true

module Oauth
  module Google
    class CreateUser < ApplicationService
      def initialize(payload:)
        @payload = payload
      end

      def call
        user = User.create!(
          email: main_email,
          password: SecureRandom.hex(20),
          confirmed_at: Time.current
        )
        Success(user)
      end

      private

      attr_reader :payload

      def main_email
        payload[:emails].first[:value]
      end
    end
  end
end
