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

      if range.include?(subtract)
        split_time_range
      else
        trim_time_range
      end
    end

    private

    def split_time_range
      [range.first..subtract.first, subtract.last..range.last]
    end

    def trim_time_range
      if range.first > subtract.first
        [subtract.last..range.last]
      else
        [range.first..subtract.first]
      end
    end

    attr_reader :range, :subtract
  end
end
