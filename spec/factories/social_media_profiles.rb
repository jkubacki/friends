# frozen_string_literal: true

FactoryBot.define do
  factory :social_media_profile do
    user_id { nil }
    provider { "google" }
    uid { nil }
  end
end
