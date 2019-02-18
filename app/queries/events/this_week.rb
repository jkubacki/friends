# frozen_string_literal: true

module Events
  class ThisWeek < ApplicationQuery
    def initialize(group:)
      @group = group
    end

    def call
      Event
        .where(group: group)
        .where("date >= ? AND date < ?", beggining_of_this_week, beggining_of_the_next_week)
    end

    private

    attr_reader :group

    def beggining_of_this_week
      Date.today.at_beginning_of_week
    end

    def beggining_of_the_next_week
      Date.today.next_occurring(:monday)
    end
  end
end
