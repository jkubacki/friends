# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oauth::Google::Authenticate do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(access_code: "access_code") }

  let(:user_data) do
    {
      emails: [{ value: "user@example.com" }, { value: "user2@example.com" }],
      id: 1
    }
  end
  let(:user) { build_stubbed(:user) }
  let(:social_media_profile) { build_stubbed(:social_media_profile) }

  before do
    allow(Oauth::Google::FetchUserData).to receive(:call).and_return(Success(user_data))
    allow(Oauth::Google::CreateUser).to receive(:call).and_return(Success(user))
    allow(SocialMediaProfile).to receive(:find_or_create_by!).and_return(social_media_profile)
  end

  it "fetches user data" do
    expect(Oauth::Google::FetchUserData).to receive(:call).with(access_code: "access_code").once
    subject
  end

  shared_examples "creates social media profile and returns user" do
    it "creates social media profile" do
      expect(SocialMediaProfile).to(
        receive(:find_or_create_by!).with(
          user_id: user.id,
          provider: "google",
          uid: user_data[:id]
        )
      ).once
      subject
    end

    it "returns success with user" do
      expect(subject.value!).to eq user
    end
  end

  context "when user with either of emails exists" do
    let(:email) { %w[user@example.com user2@example.com].sample }
    let(:user) { create(:user, email: email) }

    before { user }

    it "doesn't create user" do
      expect(Oauth::Google::CreateUser).not_to receive(:call)
      subject
    end

    it_behaves_like "creates social media profile and returns user"
  end

  context "when user with emails doesn't exist" do
    it "creates user" do
      expect(Oauth::Google::CreateUser).to receive(:call).with(user_data: user_data).once
      subject
    end

    it_behaves_like "creates social media profile and returns user"
  end
end
