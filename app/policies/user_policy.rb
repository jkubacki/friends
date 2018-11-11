# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    current_user == record
  end
end
