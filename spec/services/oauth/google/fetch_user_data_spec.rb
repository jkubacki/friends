# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oauth::Google::FetchUserData do
  include Dry::Monads::Result::Mixin

  subject { described_class.call(access_code: "access_code") }

  before do
    allow(Oauth::Google::FetchAccessToken).to receive(:call).and_return(Success("access_token"))
  end

  context "when fetch request is a failure" do
    before { VCR.insert_cassette("services/oauth/google/fetch_user_data/failure") }

    after { VCR.eject_cassette }

    it "returns failure with response body" do
      expect(subject.failure).to eq(
        error: {
          code: 403,
          errors: [
            {
              domain: "domain",
              extendedHelp: "https://code.google.com/apis/console",
              message: "message",
              reason: "reason"
            }
          ],
          message: "Error message"
        }
      )
    end
  end

  context "when fetch request is a success" do
    before { VCR.insert_cassette("services/oauth/google/fetch_user_data/success") }

    after { VCR.eject_cassette }

    it "returns success with user data" do
      expect(subject.value!).to eq(
        circledByCount: 1,
        displayName: "John Doe",
        emails: [{ type: "account", value: "user@example.com" }],
        etag: "etag",
        gender: "male",
        id: "1",
        image: { isDefault: false, url: "https://lh5.googleusercontent.com/url/photo.jpg?sz=50" },
        isPlusUser: true,
        kind: "plus#person",
        language: "pl",
        name: { familyName: "Doe", givenName: "John" },
        objectType: "person",
        url: "https://plus.google.com/1",
        verified: false
      )
    end
  end
end
