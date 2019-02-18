# frozen_string_literal: true

class GroupResource < ApplicationResource
  attributes :meeting_length_in_minutes, :creator_required, :min_users_in_meeting

  has_one :creator, class_name: "User"
end
