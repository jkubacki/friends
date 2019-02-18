# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    meeting_length_in_minutes { 60 }
    creator_required { false }
    min_users_in_meeting { 0 }
    creator
  end
end
