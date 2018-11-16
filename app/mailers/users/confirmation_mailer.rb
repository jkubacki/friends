# frozen_string_literal: true

module Users
  class ConfirmationMailer < ApplicationMailer
    def send_confirmation(user_id)
      @user = User.find(user_id)
      @confirmation_url =
        "#{Rails.application.credentials.frontend_host}/confirm-email?" \
        "confirmation_token=#{@user.confirmation_token}"
      mail(to: @user.email, subject: "Confirm your account")
    end
  end
end
