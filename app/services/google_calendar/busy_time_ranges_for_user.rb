# frozen_string_literal: true

module GoogleCalendar
  class BusyTimeRangesForUser < ApplicationService
    def initialize(user:, time_range:)
      @user = user
      @time_range = time_range
    end

    def call
      # TODO, implement calendar integration
      Success([])
    end

    private

    attr_accessor :user, :time_range
  end
end
