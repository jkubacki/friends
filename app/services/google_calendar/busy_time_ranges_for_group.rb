# frozen_string_literal: true

module GoogleCalendar
  class BusyTimeRangesForGroup < ApplicationService
    def initialize(group:, time_range:)
      @group = group
      @time_range = time_range
    end

    def call
      time_ranges =
        group.members.inject([]) do |busy_time_ranges, user|
          yield result = busy_time_ranges_for_user(user)
          busy_time_ranges + result.value!
        end
      Success(time_ranges.uniq)
    end

    private

    def busy_time_ranges_for_user(user)
      GoogleCalendar::BusyTimeRangesForUser.call(user: user, time_range: time_range)
    end

    attr_reader :group, :time_range
  end
end
