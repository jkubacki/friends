# frozen_string_literal: true

module Helpers
  module TimeRangeHelpers
    def time_range(hour_from, hour_to, day = nil)
      time(hour_from, day)..time(hour_to, day)
    end

    def time(hour, day = nil)
      day_string = day.present? ? day.to_s : '2019-02-02'
      "#{day_string} #{hour}:00:00 UTC".to_time
    end
  end
end
