# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::Users::Confirmations::Create, type: :request do
  include Dry::Monads::Result::Mixin

  subject { post "/api/v1/users/confirmations", params: params, headers: headers }

  let(:headers) { { "ACCEPT" => "application/vnd.api+json" } }
  let(:params) do
    {
      data: {
        type: "users",
        attributes: {
          confirmation_token: "confirmation_token"
        }
      }
    }
  end
  let(:confirmation_result) { Success(user) }
  let(:user) { build_stubbed(:user) }

  before { allow(Users::Confirm).to receive(:call).and_return(confirmation_result) }

  it "confirms user" do
    expect(Users::Confirm).to receive(:call).with(confirmation_token: "confirmation_token").once
    subject
  end

  context "when confirmation succeeds" do
    let(:confirmation_result) { Success(nil) }

    it "returns 204" do
      subject
      expect(response.status).to eq 204
    end
  end

  context "when confirmation fails" do
    let(:confirmation_result) { Failure("failure message") }

    it "returns 422 with message from failure" do
      subject
      expect(response.status).to eq 422
      body = Oj.load(response.body)
      expect(body["errors"].first["title"]).to eq "failure message"
    end
  end
end
