# frozen_string_literal: true

module Scheduling
  class SubtractTimeRange < ApplicationService
    def initialize(range:, subtract:)
      @range = range
      @subtract = subtract
    end

    def call
      return [range] unless range.overlaps?(subtract)
      return [] if subtract.include?(range)

      should_split? ? split_time_range : trim_time_range
    end

    private

    def should_split?
      range.first < subtract.first && range.last > subtract.last
    end

    def split_time_range
      [range.first..subtract.first, subtract.last..range.last]
    end

    def trim_time_range
      if range.first >= subtract.first
        [subtract.last..range.last]
      else
        [range.first..subtract.first]
      end
    end

    attr_reader :range, :subtract
  end
end
