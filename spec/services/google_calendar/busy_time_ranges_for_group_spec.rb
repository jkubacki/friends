# frozen_string_literal: true

require "rails_helper"

RSpec.describe GoogleCalendar::BusyTimeRangesForGroup do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(group: group, utc_from: 10, utc_to: 18) }

  let(:group) { build_stubbed(:group) }
  let(:members) { [member1, member2] }
  let(:member1) { build_stubbed(:user) }
  let(:member2) { build_stubbed(:user) }

  before do
    allow(group).to receive(:members).and_return(members)
    allow(GoogleCalendar::BusyTimeRangesForUser).to(
      receive(:call)
      .with(user: member1, utc_from: 10, utc_to: 18)
      .and_return(Success([time_range(1, 2)]))
    )
    allow(GoogleCalendar::BusyTimeRangesForUser).to(
      receive(:call).with(user: member2, utc_from: 10, utc_to: 18).and_return(member2_result)
    )
  end

  context "when BusyTimeRangesForUser is a failure" do
    let(:member2_result) { Failure(nil) }

    it "returns failure" do
      expect(subject).to eq member2_result
    end
  end

  context "when BusyTimeRangesForUser is a success" do
    let(:member2_result) { Success([time_range(1, 2), time_range(3, 4)]) }

    it "returns unique busy time ranges for all members" do
      expect(subject.value!).to eq [time_range(1, 2), time_range(3, 4)]
    end
  end
end
