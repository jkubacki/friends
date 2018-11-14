# frozen_string_literal: true

module API
  module V1
    module Helpers
      # Helpers for JSON API
      module JSONAPIHelpers
        extend Grape::API::Helpers

        # JSON 415 error response on unsupported media type
        # @return [void]
        def check_accept_header!
          return if request.headers["Accept"] == "application/vnd.api+json"

          return_error!(415, message: "Unsupported Media Type")
        end

        # Helper for easy fetching JSON API attributes from params.
        # @param params [Hash]
        # @param any [Boolean] true if any of attributes should be present
        # @return [Hash] including resource's attributes
        def json_api_attributes(any = true)
          attributes = params[:data][:attributes]
          return_error!(400, message: "Missing attributes") if attributes.blank? && any
          attributes
        end

        # Helper for returning error response
        # Include error description and backtrace only in development
        # @return [void]
        def return_error!(status, message_hash, err = nil)
          error = build_error_hash(message_hash, status)
          if Rails.env.development? && err.present?
            error[:description] = err.message
            error[:backtrace] = err.backtrace
          end
          error!({ errors: [error] }, status)
        end

        # Helper for returning response with many errors.
        # It requires errors messages and details formatted in ActiveRecord way
        # as `ActiveModel::Errors`.
        # All errors objects have the same http status.
        # More information in {Requests::SerializeErrors} documentation.
        # @return [void]
        def return_errors_array!(status, messages, details)
          result = Requests::SerializeErrors.call(
            messages: messages, details: details, status: status
          )
          error!(result.value!, status)
        end

        # Helper for easy fetching JSON API relationships id from params.
        # @return [Integer] related resource id
        def relation_id(relation)
          relationships&.dig(relation, :data, :id)
        end

        # Helper for returning whole relationships data from params.
        # @return [Hash] including relations
        def relationships
          params[:data][:relationships]
        end

        # Helper for returning included associations on response render
        # @return [Hash] including association for JSON API render
        def render_options(context: {}, meta: {})
          options[:include] = params[:include].to_s.split(",")
          options[:meta] = meta if meta.present?
          options[:context] = context
          options
        end

        private

        def build_error_hash(error_hash, status)
          {
            title: error_hash[:message],
            detail: error_hash[:detail],
            code: error_hash[:code].presence || error_hash[:message].parameterize.underscore,
            status: status
          }
        end
      end
    end
  end
end
