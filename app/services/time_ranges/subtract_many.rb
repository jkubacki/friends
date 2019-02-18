# frozen_string_literal: true

module TimeRanges
  class SubtractMany < ApplicationService
    def initialize(range:, subtract_time_ranges:)
      @range = range
      @subtract_time_ranges = subtract_time_ranges
    end

    def call
      subtract_time_ranges.inject([range]) do |time_ranges, subtract|
        subtract_from(time_ranges, subtract)
      end
    end

    private

    def subtract_from(from_time_ranges, subtract)
      from_time_ranges.inject([]) do |time_ranges, timerange|
        time_ranges + TimeRanges::Subtract.call(range: timerange, subtract: subtract)
      end
    end

    attr_reader :range, :subtract_time_ranges
  end
end
