# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :group
  belongs_to :proposition

  validates :group, :proposition, :date, presence: true
end
