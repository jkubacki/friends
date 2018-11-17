# frozen_string_literal: true

module Oauth
  module Google
    class CreateUser < ApplicationService
      def initialize(user_data:)
        @user_data = user_data
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

      attr_reader :user_data

      def main_email
        user_data[:emails].first[:value]
      end
    end
  end
end
