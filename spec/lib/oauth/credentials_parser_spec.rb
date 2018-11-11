# frozen_string_literal: true

require "rails_helper"

describe Oauth::CredentialsParser do
  subject { described_class.call(request) }

  let(:request) { OpenStruct.new(params: { "provider" => provider }) }

  context "when unknown provider passed" do
    let(:provider) { %w[quora instagram].sample }

    it { is_expected.to be nil }
  end

  context "when known provider passed" do
    let(:provider) { "google" }

    it "returns credentials" do
      expect(subject.length).to eq 2
    end
  end
end
