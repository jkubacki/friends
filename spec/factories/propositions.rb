# frozen_string_literal: true

FactoryBot.define do
  factory :proposition do
    group
    date { DateTime.current }
    status { "pending" }
  end
end
