# frozen_string_literal: true

shared_context "when authenticated" do
  let(:headers) do
    {
      "ACCEPT" => "application/vnd.api+json",
      "Authorization" => "Bearer #{access_token}"
    }
  end
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
end

shared_context "when not authenticated" do
  let(:headers) { { "ACCEPT" => "application/vnd.api+json" } }
end
