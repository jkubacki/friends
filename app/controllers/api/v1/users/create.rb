# frozen_string_literal: true

module API
  module V1
    module Users
      class Create < Base
        helpers V1::Helpers::JSONAPIParamsHelpers
        helpers Pundit

        desc "Create a user"
        params do
          use :json_api_request,
              id?: false,
              type: %w[users],
              required: [
                { name: :email, type: String, desc: "Email address" },
                { name: :password, type: String, desc: "Password" },
                { name: :password_confirmation, type: String, desc: "Password confirmation" }
              ]
        end
        post do
          authorize User, :create?
          result = ::Users::Create.call(json_api_attributes.symbolize_keys)
          if result.failure?
            user = result.failure
            return_errors_array!(422, user.errors.messages, user.errors.details)
          end
          render result.value!
        end
      end
    end
  end
end
