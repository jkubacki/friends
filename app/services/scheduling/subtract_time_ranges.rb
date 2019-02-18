# frozen_string_literal: true

module Scheduling
  class SubtractTimeRanges < ApplicationService
    def initialize(range:, subtract_time_ranges:)
      @range = range
      @subtract_time_ranges = subtract_time_ranges
    end

    def call
      available_timeranges = [range]

      subtract_time_ranges.each do |subtract|
        available_timeranges = available_timeranges.inject([]) do |timeranges, timerange|
          timeranges + TimeRanges::Subtract.call(range: timerange, subtract: subtract)
        end
      end

      available_timeranges
    end

    private

    attr_reader :range, :subtract_time_ranges
  end
end
