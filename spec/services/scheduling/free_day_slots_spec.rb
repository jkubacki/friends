# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::FreeDaySlots do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(group: group, day: day, awake_hours: awake_hours) }

  let(:group) { build_stubbed(:group) }
  let(:day) { Date.today }
  let(:awake_hours) { { utc_wakeup: 10, utc_bedtime: 18 } }

  let(:google_result) { Success(nil) }
  let(:available_time_ranges) { [available_time_range] }
  let(:available_time_range) { time_range(12, 15, day) }
  let(:long_enough) { false }

  before do
    allow(GoogleCalendar::BusyTimeRangesForGroup).to receive(:call).and_return(google_result)
    allow(Scheduling::SubtractTimeRanges).to receive(:call).and_return(available_time_ranges)
    allow(Scheduling::TimeRangeLongEnough).to receive(:call).and_return(long_enough)
  end

  context "when GoogleCalendar::BusyTimeRangesForGroup fails" do
    let(:google_result) { Failure(nil) }

    it "returns google failure" do
      expect(subject).to eq google_result
    end
  end

  context "when GoogleCalendar::BusyTimeRangesForGroup succeeds" do
    let(:google_result) { Success(busy_time_ranges) }
    let(:busy_time_ranges) { [time_range(10, 12, day), time_range(15, 18, day)]}

    it "calls SubtractTimeRanges with calendar busy time and awake hours time range" do
      expect(Scheduling::SubtractTimeRanges).to(
        receive(:call)
        .with(timerange: time_range(10, 18, day), subtract_time_ranges: busy_time_ranges)
      ).once
      subject
    end

    it "calls Scheduling::TimeRangeLongEnough for each available time ranges" do
      expect(Scheduling::TimeRangeLongEnough).to(
        receive(:call).with(group: group, time_range: available_time_range)
      ).once
      subject
    end

    context "when time range is not long enough" do
      it "doesn't return available time range" do
        expect(subject.value!).to eq []
      end
    end

    context "when time range is long enough" do
      let(:long_enough) { true }

      it "returns available time range" do
        expect(subject.value!).to eq [available_time_range]
      end
    end
  end
end
