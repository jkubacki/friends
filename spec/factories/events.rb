# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    group { nil }
    proposition { nil }
    date { DateTime.current }
  end
end
