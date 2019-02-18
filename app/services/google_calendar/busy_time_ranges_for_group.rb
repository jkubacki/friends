# frozen_string_literal: true

module GoogleCalendar
  class BusyTimeRangesForGroup < ApplicationService
    def initialize(group:, utc_from:, utc_to:)
      @group = group
      @utc_from = utc_from
      @utc_to = utc_to
    end

    def call
      busy_time_ranges = []
      group.members.each do |user|
        result =
          GoogleCalendar::BusyTimeRangesForUser
          .call(user: user, utc_from: utc_from, utc_to: utc_to)
        return result if result.failure?

        busy_time_ranges += result.value!
      end
      Success(busy_time_ranges.uniq)
    end

    private

    attr_reader :group, :utc_from, :utc_to
  end
end
