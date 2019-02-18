# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::ThisWeek do
  subject { described_class.call(group: group) }

  let!(:group) { create(:group) }
  let!(:event) { create(:event, group: event_group, date: date) }
  let(:event_group) { group }

  context "when event is from previous week" do
    let(:date) { 1.month.ago }

    it { is_expected.not_to include(event) }
  end

  context "when event is from this week" do
    let(:date) { 1.day.from_now }

    context "with different group" do
      let(:event_group) { create(:group) }

      it { is_expected.not_to include(event) }
    end

    context "with the same group" do
      it { is_expected.to include(event) }
    end
  end
end
