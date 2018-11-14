# frozen_string_literal: true

module Users
  class Create < ApplicationService
    def initialize(email:, password:, password_confirmation:)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )
      user.save ? Success(user) : Failure(user)
    end

    private

    attr_reader :email, :password, :password_confirmation
  end
end
