# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::FreeWeekendSlot do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(group: group) }

  let(:group) { build_stubbed(:group) }
  let(:saturday) { Date.today }
  let(:sunday) { Date.tomorrow }
  let(:free_day_slot_result) { Success(nil) }
  let(:awake_hours) { double }

  before do
    allow(Scheduling::WeekendDays).to receive(:call).and_return([saturday, sunday])
    allow(Scheduling::FreeDaySlot).to receive(:call).and_return(free_day_slot_result)
    allow(Scheduling::AwakeHours).to receive(:call).and_return(awake_hours)
  end

  it "looks for a slot for each weekend days" do
    [saturday, sunday].each do |day|
      expect(Scheduling::FreeDaySlot).to(
        receive(:call).with(group: group, day: day, awake_hours: awake_hours)
      ).once
    end
    subject
  end

  context "when Scheduling::FreeDaySlot fails" do
    let(:free_day_slot_result) { Failure(nil) }

    it "returns failure" do
      expect(subject).to eq free_day_slot_result
    end
  end

  context "when Scheduling::FreeDaySlot is empty for each day" do
    it "returns success with empty array" do
      expect(subject.value!).to eq []
    end
  end

  context "when Scheduling::FreeDaySlot returns time ranges" do
    let(:free_day_slot_result) { Success([time_range(10, 12)]) }

    it "returns first successfull non-empty result" do
      expect(subject).to eq free_day_slot_result
    end
  end
end
