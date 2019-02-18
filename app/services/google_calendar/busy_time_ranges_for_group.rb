# frozen_string_literal: true

module GoogleCalendar
  class BusyTimeRangesForGroup < ApplicationService
    def initialize(group:, time_range:)
      @group = group
      @time_range = time_range
    end

    def call
      busy_time_ranges = []
      group.members.each do |user|
        result = GoogleCalendar::BusyTimeRangesForUser.call(user: user, time_range: time_range)
        return result if result.failure?

        busy_time_ranges += result.value!
      end
      Success(busy_time_ranges.uniq)
    end

    private

    attr_reader :group, :time_range
  end
end
