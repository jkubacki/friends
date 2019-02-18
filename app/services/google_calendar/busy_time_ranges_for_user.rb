# frozen_string_literal: true

module GoogleCalendar
  class BusyTimeRangesForUser < ApplicationService
    def initialize(user:, utc_from:, utc_to:)
      @user = user
      @utc_from = utc_from
      @utc_to = utc_to
    end

    def call
      # TODO, implement calendar integration
      []
    end

    private

    attr_accessor :user, :utc_from, :utc_to
  end
end
