# frozen_string_literal: true

require "rails_helper"

describe API::V1::Users::Me::Show, type: :request do
  subject { get "/api/v1/users/me", headers: headers }

  context "when not authenticated" do
    include_context "when not authenticated"

    it "returns 401 status" do
      subject
      expect(response.code).to eq "401"
    end
  end

  context "when authenticated" do
    include_context "when authenticated"
    include_context "when authorized", UserPolicy, :me?

    it "renders current user" do
      subject
      expect(response_body["data"]["type"]).to eq "users"
      expect(response_body["data"]["id"]).to eq user.id.to_s
    end
  end
end
