# frozen_string_literal: true

module Oauth
  module CredentialsParser
    OAUTH_PROVIDERS = %w[google].map(&:freeze).freeze

    def self.call(request)
      provider = request.params["provider"]
      return unless OAUTH_PROVIDERS.include?(provider)

      credentials(provider)
    end

    def self.credentials(provider)
      [
        Rails.application.credentials["#{provider}_client_id"],
        Rails.application.credentials["#{provider}_client_secret"]
      ]
    end
  end
end
