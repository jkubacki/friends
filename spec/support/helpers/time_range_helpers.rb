# frozen_string_literal: true

module Helpers
  module TimeRangeHelpers
    def time_range(hour_from, hour_to)
      time(hour_from)..time(hour_to)
    end

    def time(hour)
      "2019-02-02 #{hour}:00:00 UTC".to_time
    end
  end
end
