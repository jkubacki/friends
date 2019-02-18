# frozen_string_literal: true

require "rails_helper"

describe API::V1::Helpers::JSONAPIHelpers do
  include Rack::Test::Methods
  include Dry::Monads::Result::Mixin

  subject do
    module API
      module V1
        def self.set(dynamic_name)
          @@dynamic_name = dynamic_name
        end
      end
    end

    API::V1.set(dynamic_name)

    module API
      module V1
        Object.const_set(
          @@dynamic_name,
          Class.new(Grape::API) do
            helpers AuthHelper
            helpers V1::Helpers::JSONAPIHelpers
            helpers V1::Helpers::JSONAPIParamsHelpers
            format :json
          end
        )
      end
    end
  end

  def app
    subject
  end

  let(:dynamic_name) do
    hex = SecureRandom.hex(5)
    "Helpers#{hex}"
  end

  shared_examples "renders proper status" do
    it "renders proper status" do
      post "/", params
      expect(last_response.status).to eq status
    end
  end

  shared_examples "renders proper body" do
    it "renders proper body" do
      post "/", params
      expect(last_response_body).to eq body
    end
  end

  shared_examples "renders proper error" do
    it "renders proper error" do
      post "/", params
      expect(last_response_body).to eq body
    end
  end

  describe "#check_accept_header!" do
    before do
      subject.before { check_accept_header! }
      subject.namespace do
        post do
          "bacon"
        end
      end
    end

    context "when media type is correct" do
      let(:params) { nil }
      let(:headers) { { "Accept" => "application/vnd.api+json" } }
      let(:status) { 201 }
      let(:body) { "bacon" }

      before do
        header "Accept", "application/vnd.api+json"
      end

      it "renders proper status" do
        post "/"
        expect(last_response.status).to eq status
      end

      it "renders proper body" do
        post "/"
        expect(last_response_body).to eq body
      end
    end

    context "when media type is incorrect" do
      let(:params) { nil }
      let(:status) { 415 }
      let(:body) do
        {
          "errors" => [
            {
              "title" => "Unsupported Media Type",
              "detail" => nil,
              "code" => "unsupported_media_type",
              "status" => status
            }
          ]
        }
      end

      it "renders proper status" do
        post "/"
        expect(last_response.status).to eq status
      end

      it "renders proper error" do
        post "/"
        expect(last_response_body).to eq body
      end
    end
  end

  describe "#json_api_attributes" do
    describe "fetches attributes from JSON API request" do
      context "when attributes are present" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  required: [
                    { name: :street, type: String }
                  ],
                  optional: [
                    { name: :number, type: Integer }
                  ]
            end
            post do
              json_api_attributes
            end
          end
        end

        let(:params) do
          json_api_params(
            type: "locations",
            attributes: attributes
          )
        end
        let(:attributes) do
          {
            street: "street",
            number: 4
          }
        end
        let(:status) { 201 }
        let(:body) { attributes.stringify_keys }

        include_examples "renders proper status"
        include_examples "renders proper body"
      end
    end

    context "when attributes are not present" do
      let(:params) do
        json_api_params(
          type: "locations"
        )
      end

      context "when 'any' arg is true" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  required: [
                    { name: :street, type: String }
                  ],
                  optional: [
                    { name: :number, type: Integer }
                  ]
            end
            post do
              json_api_attributes
            end
          end
        end

        let(:status) { 400 }
        let(:body) do
          {
            "errors" => [
              {
                "title" => "Missing attributes",
                "detail" => nil,
                "code" => "missing_attributes",
                "status" => status
              }
            ]
          }
        end

        include_examples "renders proper status"
        include_examples "renders proper error"
      end

      context "when 'any' arg is false" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  required: [
                    { name: :street, type: String }
                  ],
                  optional: [
                    { name: :number, type: Integer }
                  ]
            end
            post do
              json_api_attributes(false)
            end
          end
        end

        let(:status) { 201 }
        let(:body) { nil }

        include_examples "renders proper status"
        include_examples "renders proper body"
      end
    end
  end

  describe "#return_error!" do
    before do
      subject.namespace do
        post do
          raise ActiveRecord::RecordNotFound
        rescue ActiveRecord::RecordNotFound => e
          return_error!(404, { message: "Record not found" }, e)
        end
      end
    end

    context "when in development environment" do
      describe "renders error in JSON API format" do
        let(:params) { nil }
        let(:status) { 404 }
        let(:body) do
          {
            "errors" => [
              {
                "title" => "Record not found",
                "detail" => nil,
                "code" => "record_not_found",
                "status" => status,
                "description" => "ActiveRecord::RecordNotFound"
              }
            ]
          }
        end

        before { allow(Rails.env).to receive(:development?).and_return(true) }

        include_examples "renders proper status"

        it "renders proper title, status and description in error object", :aggregated_errors do
          post "/"
          errors = last_response_body["errors"].first
          expect(errors["title"]).to eq body["errors"].first["title"]
          expect(errors["status"]).to eq body["errors"].first["status"]
          expect(errors["description"]).to eq body["errors"].first["description"]
        end

        it "returns error backtrace in an Array" do
          post "/"
          backtrace = last_response_body["errors"].first["backtrace"]
          expect(backtrace).to be_an(Array)
        end
      end
    end

    context "when in any other env than development" do
      describe "renders error in JSON API format" do
        let(:params) { nil }
        let(:status) { 404 }
        let(:body) do
          {
            "errors" => [
              {
                "title" => "Record not found",
                "detail" => nil,
                "code" => "record_not_found",
                "status" => status
              }
            ]
          }
        end

        include_examples "renders proper status"
        include_examples "renders proper error"
      end
    end
  end

  describe "#return_errors_array!" do
    before do
      subject.namespace do
        post do
          messages = {
            password_confirmation: ["doesn't match Password"],
            password: ["is too short (minimum is 6 characters)"]
          }
          details = {
            password_confirmation: [{ error: :confirmation, attribute: "Password" }],
            password: [{ error: :too_short, count: 6 }]
          }
          return_errors_array!(422, messages, details)
        end
      end
    end

    describe "renders multiple errors in JSON API format" do
      let(:params) { nil }
      let(:messages) do
        {
          password_confirmation: ["doesn't match Password"],
          password: ["is too short (minimum is 6 characters)"]
        }
      end
      let(:details) do
        {
          password_confirmation: [{ error: :confirmation, attribute: "Password" }],
          password: [{ error: :too_short, count: 6 }]
        }
      end
      let(:status) { 422 }
      let(:body) do
        {
          "errors" => [
            {
              "title" => "password_confirmation",
              "detail" => "Password confirmation doesn't match Password",
              "code" => "confirmation",
              "status" => status
            },
            {
              "title" => "password",
              "detail" => "Password is too short (minimum is 6 characters)",
              "code" => "too_short",
              "status" => status
            }
          ]
        }
      end
      let(:result) { Success(body) }

      before { allow(Requests::SerializeErrors).to receive(:call).and_return(result) }

      include_examples "renders proper status"
      include_examples "renders proper error"
    end
  end

  describe "#relation_id" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      subject.namespace do
        params do
          use :json_api_request,
              id?: false,
              relationships: [
                { name: :group, required?: true },
                { name: :user, required?: false }
              ]
        end
        post do
          "#{relation_id('user')} + #{relation_id('group')}"
        end
      end
    end

    describe "fetches attributes from JSON API request" do
      let(:params) do
        json_api_params(
          type: "locations",
          relationships: relationships
        )
      end
      let(:relationships) { [group, user] }
      let(:status) { 201 }
      let(:body) { "#{user.id} + #{group.id}" }

      include_examples "renders proper status"
      include_examples "renders proper body"
    end

    describe "returns nil if there is no relationship" do
      let(:params) do
        json_api_params(
          type: "locations",
          relationships: relationships
        )
      end
      let(:relationships) { [group] }
      let(:status) { 201 }
      let(:body) { " + #{group.id}" }

      include_examples "renders proper status"
      include_examples "renders proper body"
    end
  end

  describe "#relationships" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      subject.namespace do
        params do
          use :json_api_request,
              id?: false,
              relationships: [
                { name: :group, required?: true },
                { name: :user, required?: false }
              ]
        end
        post do
          relationships
        end
      end
    end

    describe "fetches relationships data from JSON API request" do
      let(:params) do
        json_api_params(
          type: "locations",
          relationships: relationships
        )
      end
      let(:relationships) { [group, user] }
      let(:status) { 201 }
      let(:body) do
        {
          "group" => {
            "data" => {
              "type" => "group",
              "id" => group.id
            }
          },
          "user" => {
            "data" => {
              "type" => "user",
              "id" => user.id
            }
          }
        }
      end

      include_examples "renders proper status"
      include_examples "renders proper body"
    end
  end
end
