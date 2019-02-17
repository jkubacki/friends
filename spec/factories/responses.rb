# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    user { nil }
    proposition { nil }
    confirmed { false }
  end
end
