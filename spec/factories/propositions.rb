# frozen_string_literal: true

FactoryBot.define do
  factory :proposition do
    group
    date { DateTime.current }
    status { "pending" }

    trait :accepted do
      status { "accepted" }
    end

    trait :rejected do
      status { "rejected" }
    end

    trait :pending do
      status { "pending" }
    end
  end
end
