# frozen_string_literal: true

module Users
  class ConfirmationsPolicy < ApplicationPolicy
    def create?
      true
    end
  end
end
