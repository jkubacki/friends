# frozen_string_literal: true

require "rails_helper"

describe API::V1::Users::Create, type: :request do
  include Dry::Monads::Result::Mixin

  subject { post "/api/v1/users", params: params, headers: headers }

  let(:headers) { { "ACCEPT" => "application/vnd.api+json" } }
  let(:params) do
    {
      data: {
        type: "users",
        attributes: attributes
      }
    }
  end
  let(:attributes) do
    {
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end
  let(:user) { build_stubbed(:user) }

  before { allow(Users::Create).to receive(:call).and_return(result) }

  context "when user is created successfully" do
    let(:result) { Success(user) }

    it "creates user" do
      expect(Users::Create).to receive(:call).with(attributes).once
      subject
    end

    it "renders user" do
      subject
      response_body = Oj.load(response.body)
      expect(response_body["data"]["type"]).to eq "users"
      expect(response_body["data"]["id"]).to eq user.id.to_s
    end
  end

  context "when user creation fails" do
    let(:invalid_user) { build_stubbed(:user) }
    let(:result) { Failure(invalid_user) }

    it "returns 422" do
      subject
      expect(response.status).to eq 422
    end
  end
end
