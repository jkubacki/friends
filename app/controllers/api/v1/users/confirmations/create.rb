# frozen_string_literal: true

module API
  module V1
    module Users
      module Confirmations
        class Create < Base
          helpers V1::Helpers::JSONAPIParamsHelpers
          helpers Pundit

          desc "Confirm user account"
          params do
            use :json_api_request,
                id?: false,
                type: %w[users],
                required: [
                  { name: :confirmation_token, type: String, desc: "Confirmation token" }
                ]
          end
          post do
            authorize :confirmations, :create?, policy_class: ::Users::ConfirmationsPolicy
            confirmation_token = json_api_attributes[:confirmation_token]
            result = ::Users::Confirm.call(confirmation_token: confirmation_token)
            return_error!(422, message: result.failure) if result.failure?

            body false
          end
        end
      end
    end
  end
end
