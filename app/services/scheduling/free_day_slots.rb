# frozen_string_literal: true

module Scheduling
  class FreeDaySlots < ApplicationService
    def initialize(group:, day:, awake_hours:)
      @group = group
      @day = day
      @awake_hours = awake_hours
    end

    def call
      available_time_ranges_result = available_time_ranges
      return available_time_ranges_result if available_time_ranges_result.failure?

      long_enough_time_ranges =
        available_time_ranges_result.value!.select do |time_range|
          Scheduling::TimeRangeLongEnough.call(group: group, time_range: time_range)
        end
      Success(long_enough_time_ranges)
    end

    private

    attr_reader :group, :day, :awake_hours

    def available_time_ranges
      return busy_time_ranges if busy_time_ranges.failure?

      time_ranges = Scheduling::SubtractTimeRanges.call(
        range: awake_time_range,
        subtract_time_ranges: busy_time_ranges.value!
      )
      Success(time_ranges)
    end

    def awake_time_range
      time(awake_hours[:utc_wakeup])..time(awake_hours[:utc_bedtime])
    end

    def time(hour)
      "#{day} #{hour}:00:00 UTC".to_time
    end

    def busy_time_ranges
      @busy_time_ranges ||=
        GoogleCalendar::BusyTimeRangesForGroup.call(group: group, time_range: awake_time_range)
    end
  end
end
