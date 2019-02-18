# frozen_string_literal: true

require "rails_helper"

describe GroupResource, type: :resource do
  subject { described_class.new(group, {}) }

  let(:group) { build_stubbed(:group) }

  it { is_expected.to have_attribute(:meeting_length_in_minutes) }
  it { is_expected.to have_attribute(:creator_required) }
  it { is_expected.to have_attribute(:min_users_in_meeting) }

  it { is_expected.to have_one(:creator).with_class_name("User") }
end
