# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oauth::Google::FetchAccessToken do
  subject { described_class.call(access_code: "access_code") }

  context "when fetch request fails" do
    before { VCR.insert_cassette("services/oauth/google/fetch_access_token/failure") }

    after { VCR.eject_cassette }

    it "returns failure with response body" do
      expect(subject.failure).to eq(
        "error" => "error",
        "error_description" => "error description"
      )
    end
  end

  context "when fetch request succeds" do
    before { VCR.insert_cassette("services/oauth/google/fetch_access_token/success") }

    after { VCR.eject_cassette }

    it "returns success with response body access token" do
      expect(subject.value!).to eq("access_token")
    end
  end
end
