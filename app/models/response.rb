# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :proposition
  belongs_to :user

  validates :proposition, :user, presence: true
end
