# frozen_string_literal: true

module API
  module V1
    # Base API configuration for V1, JSON API
    class Base < Core
      helpers V1::Helpers::JSONAPIHelpers
      helpers V1::Helpers::JSONAPIParamsHelpers

      before { check_accept_header! }
      after { verify_authorized }

      version "v1", using: :path, vendor: "friends"
      format :json
      formatter :json, Grape::Formatter::JSONAPIResources
      content_type :json, "application/vnd.api+json"

      log_requests = Rails.env.development? || ENV["LOG"]
      use GrapeLogging::Middleware::RequestLogger, logger: logger if log_requests

      mount Users::Base
    end
  end
end
