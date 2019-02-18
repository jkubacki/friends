# frozen_string_literal: true

require "doorkeeper/grape/helpers"

# Helpers for API authentication
module API
  module AuthHelper
    extend ::Grape::API::Helpers
    include Doorkeeper::Grape::Helpers

    APPLICATION = "application"

    # JSON unauthorized response on unauthenticated user
    # @return [void]
    def authenticate_user!
      unauthorized_error unless authenticated?
    end

    # Check if user is authenticated by doorkeeper token
    # @return [Boolean]
    def authenticated?
      doorkeeper_token.present? ? doorkeeper_authorize!.nil? : false
    end

    # Unathorized error json response
    # @return [Hash]
    def unauthorized_error
      return_error!(401, message: "Unauthorized")
    end

    # Current user
    # @return [{User}, nil]
    def current_user
      return nil unless authenticated?

      doorkeeper_user
    end

    # User from doorkeeper token or new user
    # @return [{User}]
    def doorkeeper_user
      doorkeeper_token.resource_owner_id ? User.find(doorkeeper_token.resource_owner_id) : User.new
    end
  end
end
