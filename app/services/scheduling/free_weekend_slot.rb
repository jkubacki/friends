# frozen_string_literal: true

module Scheduling
  class FreeWeekendSlot < ApplicationService
    def initialize(group:)
      @group = group
    end

    def call
      weekend_days.each do |day|
        result = Scheduling::FreeDaySlots.call(group: group, day: day, awake_hours: awake_hours)
        return result if result.failure? || result.value!.present?
      end
      Success([])
    end

    private

    attr_reader :group

    def weekend_days
      Scheduling::WeekendDays.call
    end

    def awake_hours
      @awake_hours ||= Scheduling::AwakeHours.call(group: group)
    end
  end
end
