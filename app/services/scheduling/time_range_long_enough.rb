# frozen_string_literal: true

module Scheduling
  class TimeRangeLongEnough < ApplicationService
    def initialize(group:, time_range:)
      @group = group
      @time_range = time_range
    end

    def call
      time_range_in_minutes >= group.meeting_length_in_minutes
    end

    private

    attr_reader :group, :time_range

    def time_range_in_minutes
      (time_range.last - time_range.first).to_i / 60
    end
  end
end
