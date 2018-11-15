# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    current_user == record
  end

  def create?
    true
  end
end
