# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    group
    proposition
    date { DateTime.current }
  end
end
