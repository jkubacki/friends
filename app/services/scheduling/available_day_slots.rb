# frozen_string_literal: true

module Scheduling
  class AvailableDaySlots < ApplicationService
    def initialize(group:, day:, awake_hours:)
      @group = group
      @day = day
      @awake_hours = awake_hours
    end

    def call
      yield busy_time_ranges = find_busy_time_ranges
      yield available_time_ranges_result = available_time_ranges(busy_time_ranges)
      time_ranges = filter_out_too_short_ranges(available_time_ranges_result)
      Success(time_ranges)
    end

    private

    attr_reader :group, :day, :awake_hours

    def filter_out_too_short_ranges(time_ranges)
      time_ranges.value!.select do |time_range|
        TimeRanges::LongEnough.call(group: group, time_range: time_range)
      end
    end

    def available_time_ranges(busy_time_ranges)
      time_ranges = TimeRanges::SubtractMany.call(
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

    def find_busy_time_ranges
      GoogleCalendar::BusyTimeRangesForGroup.call(group: group, time_range: awake_time_range)
    end
  end
end
