# frozen_string_literal: true

require "rails_helper"

RSpec.describe Proposition, type: :model do
  it { is_expected.to belong_to :group }

  it { is_expected.to validate_presence_of :group }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_inclusion_of(:status).in_array(described_class::STATUSES) }
end
