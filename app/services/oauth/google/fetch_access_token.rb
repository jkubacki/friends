# frozen_string_literal: true

module Oauth
  module Google
    class FetchAccessToken < ApplicationService
      def initialize(access_code:)
        @access_code = access_code
      end

      def call
        uri = URI.parse(Rails.application.credentials.google_api_token_url)
        response = Net::HTTP.post_form(uri, getch_access_token_params)
        body = Oj.load(response.body)
        response.code == "200" ? Success(body.fetch("access_token")) : Failure(body)
      end

      private

      attr_reader :access_code

      def getch_access_token_params
        {
          client_id: Rails.application.credentials.google_client_id,
          client_secret: Rails.application.credentials.google_client_secret,
          grant_type: "authorization_code",
          code: access_code,
          redirect_uri: Rails.application.credentials.google_redirect_uri
        }
      end
    end
  end
end
