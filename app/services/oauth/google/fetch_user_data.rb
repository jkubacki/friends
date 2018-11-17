# frozen_string_literal: true

module Oauth
  module Google
    class FetchUserData < ApplicationService
      def initialize(access_code:)
        @access_code = access_code
      end

      def call
        fetch_access_token
          .bind(&method(:fetch_user_data))
      end

      private

      attr_reader :access_code

      def fetch_access_token
        Oauth::Google::FetchAccessToken.call(access_code: access_code)
      end

      def fetch_user_data(access_token)
        google = URI.parse("#{Rails.application.credentials.google_api_user_url}#{access_token}")
        response = Net::HTTP.get_response(google)
        body = Oj.load(response.body, symbol_keys: true)
        response.code == "200" ? Success(body) : Failure(body)
      end
    end
  end
end
