# frozen_string_literal: true

module Users
  class Confirm < ApplicationService
    def initialize(confirmation_token:)
      @confirmation_token = confirmation_token
    end

    def call
      user = User.confirm_by_token(confirmation_token)
      return Failure(error_details(user)) if user.errors.present?

      Success(nil)
    end

    private

    def error_details(user)
      user.errors.full_messages.join(", ")
    end

    attr_reader :confirmation_token
  end
end
