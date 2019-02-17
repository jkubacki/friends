# frozen_string_literal: true

class Group < ApplicationRecord
  validates :meeting_length_in_minutes, :creator_required, :min_users_in_meeting, presence: true
end
