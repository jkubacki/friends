# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  validates :meeting_length_in_minutes, :min_users_in_meeting, :creator, presence: true
  validates :creator_required, inclusion: [true, false]
end
