# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::Schedule do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(group: group) }

  let(:group) { build_stubbed(:group) }

  let(:this_week_scope) { double }
  let(:event_for_this_week) { false }

  let(:propositions_scope) { double }
  let(:pending_proposition) { false }

  let(:weekend_slots_result) { Success(slots) }
  let(:slots) { [time_range(9, 15), time_range(18, 22)] }
  let(:radom_slot) { slots.sample }

  before do
    allow(Events::ThisWeek).to receive(:call).and_return(this_week_scope)
    allow(this_week_scope).to receive(:any?).and_return(event_for_this_week)

    allow(Proposition).to receive(:pending).with(group).and_return(propositions_scope)
    allow(propositions_scope).to receive(:any?).and_return(pending_proposition)

    allow(Scheduling::AvailableWeekendSlots).to receive(:call).and_return(weekend_slots_result)
    allow(slots).to receive(:sample).and_return(radom_slot)

    allow(Propositions::Create).to receive(:call).and_return(Success(nil))
  end

  shared_examples "returns empty success" do
    it "returns empty success" do
      expect(subject).to eq Success(nil)
    end
  end

  context "when there is an event for this weekend" do
    let(:event_for_this_week) { true }

    it_behaves_like "returns empty success"
  end

  context "when there is a pending proposition" do
    let(:pending_proposition) { true }

    it_behaves_like "returns empty success"
  end

  it "creates proposition for a random weekend slot" do
    expect(Propositions::Create).to(
      receive(:call).with(group: group, date: radom_slot.first)
    ).once
    subject
  end
end
