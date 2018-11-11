# frozen_string_literal: true

module API
  module ErrorHandlers
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound do
        return_error!(404, message: "Record not found")
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        return_errors_array!(422, e.record.errors.messages, e.record.errors.details)
      end

      rescue_from Pundit::AuthorizationNotPerformedError do |e|
        return_error!(500, { message: "Authorization Not Performed" }, e)
      end

      rescue_from :all do |e|
        status = e.try(:status) || 500
        return_error!(status, { message: e.message }, e)
      end

      rescue_from ActiveRecord::InvalidForeignKey do |_|
        return_error!(500, message: "Invalid Foreign Key")
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        return_error!(400, message: e.message)
      end

      rescue_from Pundit::NotAuthorizedError do |e|
        return_error!(403, message: e.message)
      end
    end
  end
end
