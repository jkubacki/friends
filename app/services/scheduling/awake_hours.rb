# frozen_string_literal: true

module Scheduling
  class AwakeHours < ApplicationService
    def initialize(group:)
      @group = group
    end

    WAKEUP_HOUR = 9
    BEDTIME_HOUR = 23

    def call
      { utc_wakeup: wakeup_utc, utc_bedtime: bedtime_utc }
    end

    private

    attr_reader :group

    def wakeup_utc
      WAKEUP_HOUR + group.members.maximum(:utc)
    end

    def bedtime_utc
      BEDTIME_HOUR + group.members.minimum(:utc)
    end
  end
end
