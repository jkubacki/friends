# frozen_string_literal: true

module Scheduling
  class AvailableWeekendSlots < ApplicationService
    def initialize(group:)
      @group = group
    end

    def call
      weekend_slots =
        weekend_days.inject([]) do |free_slots, day|
          yield result = available_day_slots(day)
          free_slots + result.value!
        end
      Success(weekend_slots)
    end

    private

    def available_day_slots(day)
      Scheduling::AvailableDaySlots.call(group: group, day: day, awake_hours: awake_hours)
    end

    attr_reader :group

    def weekend_days
      Scheduling::WeekendDays.call
    end

    def awake_hours
      @awake_hours ||= Scheduling::AwakeHours.call(group: group)
    end
  end
end
