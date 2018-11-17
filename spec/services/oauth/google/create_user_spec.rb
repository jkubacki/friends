# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oauth::Google::CreateUser do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.call(payload: payload) }

  let(:payload) do
    {
      emails: [{ value: "user@example.com" }, { value: "user2@example.com" }]
    }
  end
  let(:created_user) { subject.value! }
  let(:current_time) { Time.zone.local(2017, 11, 29, 11, 0) }

  before do
    allow(SecureRandom).to receive(:hex).and_return("random_password")
    travel_to(current_time)
  end

  after { travel_back }

  it "creates user with main email, random password and current created_at" do
    expect { subject }.to change(User, :count).by(1)
    expect(created_user.email).to eq "user@example.com"
    expect(created_user.password).to eq "random_password"
    expect(created_user.confirmed_at).to eq current_time
  end
end
