# frozen_string_literal: true

class EventResource < ApplicationResource
  attributes :date

  has_one :creator, class_name: "User"
  has_one :opportunity
end
