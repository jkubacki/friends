# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::SubtractTimeRanges do
  subject { described_class.call(range: range, subtract_time_ranges: subtract_time_ranges) }

  let(:range) { time_range(10, 20) }
  let(:subtract_time_ranges) do
    [time_range(13, 15), time_range(12, 16), time_range(16, 17), time_range(19, 22)]
  end

  # 1. 10-13 15-20
  # 2. 10-12 16-20
  # 3. 10-12 17-20
  # 4. 10-12 17-19
  it "returns array of time ranges left after subtracting multiple time ranges" do
    expect(subject).to eq [time_range(10, 12), time_range(17, 19)]
  end
end
