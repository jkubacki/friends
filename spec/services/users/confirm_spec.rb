# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::Confirm do
  subject { described_class.call(confirmation_token: "confirmation_token") }

  let(:user) { instance_double(User, errors: errors) }
  let(:errors) { [] }

  before do
    allow(User).to receive(:confirm_by_token).and_return(user)
  end

  it "confirms user with token" do
    expect(User).to receive(:confirm_by_token).once
    subject
  end

  context "when confirmation returns errors" do
    let(:errors) { instance_double(ActiveModel::Errors, full_messages: %w[message1 message2]) }

    it "returns failure with joined error messages" do
      expect(subject).to be_failure
      expect(subject.failure).to eq "message1, message2"
    end
  end

  context "when confirmation returns no errors" do
    let(:errors) { [] }

    it { is_expected.to be_success }
  end
end
