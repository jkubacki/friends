# frozen_string_literal: true

require "rails_helper"

RSpec.describe Proposition, type: :model do
  it { is_expected.to belong_to :group }

  it { is_expected.to validate_presence_of :group }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_inclusion_of(:status).in_array(described_class::STATUSES) }

  describe ".pending" do
    subject { described_class.pending(group) }

    let!(:accepted) { create(:proposition, :accepted) }
    let!(:rejected) { create(:proposition, :rejected) }
    let!(:pending) { create(:proposition, :pending) }

    context "without group passed" do
      let(:group) { nil }

      it "returns only pending proposition" do
        expect(subject).not_to include(accepted)
        expect(subject).not_to include(rejected)
        expect(subject).to include(pending)
      end
    end

    context "with group passed" do
      let(:group) { create(:group) }
      let!(:pending_from_group) { create(:proposition, :pending, group: group) }

      it "returns only pending proposition from group" do
        expect(subject).not_to include(accepted)
        expect(subject).not_to include(rejected)
        expect(subject).not_to include(pending)
        expect(subject).to include(pending_from_group)
      end
    end
  end
end
