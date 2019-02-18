# frozen_string_literal: true

module Scheduling
  class WeekendDays
    def self.call
      [Date.today.next_occurring(:saturday), Date.today.next_occurring(:sunday)]
    end
  end
end
