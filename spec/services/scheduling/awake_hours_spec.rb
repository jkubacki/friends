# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scheduling::AwakeHours do
  subject { described_class.call(group: group) }

  let(:group) { create(:group) }

  before do
    create(:membership, group: group, user: create(:user, utc: -5))
    create(:membership, group: group, user: create(:user, utc: +1))
  end

  it "returns daytime hours common to the members in different timezones" do
    expect(subject).to eq(utc_wakeup: 9 + 1, utc_bedtime: 23 - 5)
  end
end
