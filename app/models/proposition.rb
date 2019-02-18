# frozen_string_literal: true

class Proposition < ApplicationRecord
  belongs_to :group

  STATUSES = %w[pending accepted rejected].freeze

  validates :group, :date, :status, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
end
