# frozen_string_literal: true

require "rails_helper"

RSpec.describe Group, type: :model do
  it { is_expected.to belong_to :creator }
  it { is_expected.to have_many :memberships }
  it { is_expected.to have_many(:members).through(:memberships) }

  it { is_expected.to validate_presence_of :meeting_length_in_minutes }
  it { is_expected.to allow_value(true, false).for(:creator_required) }
  it { is_expected.to validate_presence_of :min_users_in_meeting }
  it { is_expected.to validate_presence_of :creator }
end
