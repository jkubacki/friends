# frozen_string_literal: true

class UserResource < ApplicationResource
  attributes :email

  def fetchable_fields
    context[:endpoint] == "users/me" ? super : super - [:email]
  end
end
