# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::SubtractTimeRange do
  subject { described_class.call(range: range, subtract: subtract) }

  let(:range) { time_range(8, 11) }

  context "when subtract doesn't overlap with ranges" do
    let(:subtract) { time_range(12, 14) }

    it "returns original range" do
      expect(subject).to eq [range]
    end
  end

  context "when subtract overlaps with the beggining of time range" do
    let(:subtract) { time_range(7, 9) }

    it "returns time range with trimmed beggining" do
      expect(subject).to eq [time(9)..range.last]
    end
  end

  context "when subtract overlaps with the end of time range" do
    let(:subtract) { time_range(10, 15) }

    it "returns time range with trimmed end" do
      expect(subject).to eq [range.first..time(10)]
    end
  end

  context "when subtract is included inside time range" do
    let(:subtract) { time_range(9, 10) }

    it "returns two new time ranges divided by subtract" do
      expect(subject).to eq(
        [
          range.first..time(9),
          time(10)..range.last
        ]
      )
    end
  end

  context "when time range is included in subtract" do
    let(:subtract) { time_range(7, 11) }

    it "removes time range from results" do
      expect(subject).to eq []
    end
  end
end
