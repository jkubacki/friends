# frozen_string_literal: true

require "rails_helper"

describe EventResource, type: :resource do
  subject { described_class.new(event, {}) }

  let(:event) { build_stubbed(:event) }

  it { is_expected.to have_attribute(:date) }

  it { is_expected.to have_one(:opportunity).with_class_name("Opportunity") }
end
