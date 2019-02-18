# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimeRanges::LongEnough do
  subject { described_class.call(group: group, time_range: range) }

  let(:group) { build_stubbed(:group, meeting_length_in_minutes: meeting_length_in_minutes) }
  let(:range) { time_range(1, 5) }

  context "when meeting time is more than time range" do
    let(:meeting_length_in_minutes) { 5 * 60 }

    it { is_expected.to eq false }
  end

  context "when meeting time is equal to time range" do
    let(:meeting_length_in_minutes) { 4 * 60 }

    it { is_expected.to eq true }
  end

  context "when meeting time is less than time range" do
    let(:meeting_length_in_minutes) { 3 * 60 }

    it { is_expected.to eq true }
  end
end
