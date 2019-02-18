# frozen_string_literal: true

module Scheduling
  class Schedule < ApplicationService
    def initialize(group:)
      @group = group
    end

    def call
      return Success(nil) if event_for_this_week? || pending_proposition?

      yield slots_result = free_weekend_slots
      slots = slots_result.value!
      return Success(nil) if slots.empty?

      date = pick_random_date(slots)
      Propositions::Create.call(group: group, date: date)
    end

    private

    attr_reader :group

    def event_for_this_week?
      Events::ThisWeek.call(group: group).any?
    end

    def pending_proposition?
      Proposition.pending(group).any?
    end

    def free_weekend_slots
      Scheduling::FreeWeekendSlots.call(group: group)
    end

    def pick_random_date(slots)
      slots.sample.first
    end
  end
end
