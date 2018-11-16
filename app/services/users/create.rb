# frozen_string_literal: true

module Users
  class Create < ApplicationService
    def initialize(email:, password:, password_confirmation:)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      create_user_record
        .bind(&method(:send_confirmation_email))
    end

    private

    def create_user_record
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )
      user.save ? Success(user) : Failure(user)
    end

    def send_confirmation_email(user)
      Users::ConfirmationMailer.send_confirmation(user.id).deliver_later
      Success(user)
    end

    attr_reader :email, :password, :password_confirmation
  end
end
