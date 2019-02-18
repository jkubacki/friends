# frozen_string_literal: true

require "rails_helper"

describe API::V1::Helpers::JSONAPIParamsHelpers do
  include Rack::Test::Methods

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
    "ParamsHelpers#{hex}"
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

  describe ":json_api_include" do
    context "when resource and resource associations are present" do
      before do
        subject.namespace do
          params do
            use :json_api_include, resource: DummyResource
          end
          post do
            params[:include]
          end
        end
      end

      describe "allows to provide included resources string" do
        let(:params) do
          {
            include: "user,group"
          }
        end
        let(:status) { 201 }
        let(:body) { params[:include] }

        include_examples "renders proper status"
        include_examples "renders proper body"
      end

      describe "validates type of included data" do
        let(:params) do
          {
            include: {
              integer: 4
            }
          }
        end
        let(:status) { 400 }
        let(:body) { { "error" => "include is invalid" } }

        include_examples "renders proper status"
        include_examples "renders proper error"
      end
    end

    context "when resource is missing" do
      before do
        subject.namespace do
          params do
            use :json_api_include
          end
          post do
            params[:include]
          end
        end
      end

      let(:params) do
        {
          include: 4
        }
      end

      it "doesn't bear in mind 'include' parameter" do
        post "/", params
        expect(last_response.status).to eq 201
      end
    end
  end

  describe ":json_api_request" do
    describe "helper without arguments requires data and type" do
      before do
        subject.namespace do
          params do
            use :json_api_request
          end
          post do
            "bacon"
          end
        end
      end

      context "when type is provided" do
        let(:params) do
          json_api_params(
            type: "users"
          )
        end
        let(:status) { 201 }
        let(:body) { "bacon" }

        include_examples "renders proper status"
        include_examples "renders proper body"
      end

      context "when data and type is not provided" do
        let(:params) { nil }
        let(:status) { 400 }
        let(:body) { { "error" => "data is missing, data[type] is missing" } }

        include_examples "renders proper status"
        include_examples "renders proper error"
      end
    end

    describe "helper for resource id" do
      context "when id isn't required" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false
            end
            post do
              "bacon"
            end
          end
        end

        context "when id is not provided" do
          let(:params) do
            json_api_params(
              type: "users"
            )
          end
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end
      end

      context "when id is required" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: true
            end
            post do
              "bacon"
            end
          end
        end

        context "when required params are provided" do
          let(:params) do
            json_api_params(
              id: 1,
              type: "users"
            )
          end
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when reuired params are not provided" do
          let(:params) { nil }
          let(:status) { 400 }
          let(:body) do
            { "error" => "data is missing, data[id] is missing, data[type] is missing" }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end
    end

    describe "helper validates type" do
      before do
        subject.namespace do
          params do
            use :json_api_request,
                id?: true,
                type: %w[users]
          end
          post do
            "bacon"
          end
        end
      end

      context "when type is correct provided" do
        let(:params) do
          json_api_params(
            id: 1,
            type: "users"
          )
        end
        let(:status) { 201 }
        let(:body) { "bacon" }

        include_examples "renders proper status"
        include_examples "renders proper body"
      end

      context "when type is incorrect" do
        let(:params) do
          json_api_params(
            id: 1,
            type: "group"
          )
        end
        let(:status) { 400 }
        let(:body) { { "error" => "data[type] does not have a valid value" } }

        include_examples "renders proper status"
        include_examples "renders proper error"
      end
    end

    describe "helper for attributes" do
      describe "validates attributes requirement" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  type: %w[locations],
                  required: [
                    { name: :street, type: String }
                  ],
                  optional: [
                    { name: :number, type: Integer }
                  ]
            end
            post do
              "bacon"
            end
          end
        end

        context "when only required attributes are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              attributes: { street: "street" }
            )
          end
          let(:attributes) do
            {
              street: "street"
            }
          end
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when both attributes are provided" do
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
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when required attributes are not provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              attributes: attributes
            )
          end
          let(:attributes) do
            {
              number: 4
            }
          end
          let(:status) { 400 }
          let(:body) { { "error" => "data[attributes][street] is missing" } }

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end

      describe "validates attributes type" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  type: %w[locations],
                  required: [
                    { name: :street, type: String }
                  ],
                  optional: [
                    { name: :number, type: Integer }
                  ]
            end
            post do
              "bacon"
            end
          end
        end

        context "when attributes do not have propper type" do
          let(:params) do
            json_api_params(
              type: "locations",
              attributes: attributes
            )
          end
          let(:attributes) do
            {
              street: { bacon: "street" },
              number: "bacon"
            }
          end
          let(:status) { 400 }
          let(:body) do
            {
              "error" => "data[attributes][street] is invalid, data[attributes][number] is invalid"
            }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end

      describe "validates attributes values" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  type: %w[locations],
                  required: [
                    { name: :street, type: String, values: %w[street] }
                  ],
                  optional: [
                    { name: :number, type: Integer, values: [4, 6] }
                  ]
            end
            post do
              "bacon"
            end
          end
        end

        context "when attributes have values different from described in controller" do
          let(:params) do
            json_api_params(
              type: "locations",
              attributes: attributes
            )
          end
          let(:attributes) do
            {
              street: "city",
              number: 1
            }
          end
          let(:status) { 400 }
          let(:body) do
            {
              "error" => "data[attributes][street] does not have a valid value, "\
                        "data[attributes][number] does not have a valid value"
            }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end

      describe "ascribes default values for optional attributes" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  id?: false,
                  type: %w[locations],
                  required: [
                    { name: :street, type: String, default: "street" }
                  ],
                  optional: [
                    { name: :number, type: Integer, default: 4 }
                  ]
            end
            post do
              "#{params[:data][:attributes][:street]} #{params[:data][:attributes][:number]}"
            end
          end
        end

        context "when optional attributes are not provided in request" do
          let(:params) do
            json_api_params(
              type: "locations",
              attributes: attributes
            )
          end
          let(:attributes) do
            {
              street: "city"
            }
          end
          let(:status) { 201 }
          let(:body) { "city 4" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end
      end
    end

    describe "helper for relationships" do
      let(:user) { create(:user) }
      let(:group) { create(:group) }

      describe "validates relationships requirement" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  relationships: [
                    { name: :group, required?: true },
                    { name: :user, required?: false }
                  ]
            end
            post do
              "bacon"
            end
          end
        end

        context "when only required relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when both relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group, user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when required relationships are not provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [user] }
          let(:status) { 400 }
          let(:body) do
            {
              "error" => "data[relationships][group] is missing, "\
                        "data[relationships][group][data] is missing, "\
                        "data[relationships][group][data][type] is missing, "\
                        "data[relationships][group][data][id] is missing"
            }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end

      describe "validates `all_or_none_of` relationships" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  relationships: [
                    { name: :group, required?: false },
                    { name: :user, required?: false }
                  ],
                  validation: %i[all_or_none_of group user]
            end
            post do
              "bacon"
            end
          end
        end

        context "when all relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group, user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when non relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { nil }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when one relationships is provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [user] }
          let(:status) { 400 }
          let(:body) { { "error" => "group, user provide all or none of parameters" } }

          include_examples "renders proper status"
          include_examples "renders proper error"
        end
      end

      describe "validates `at_least_one_of` relationships" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  relationships: [
                    { name: :group, required?: false },
                    { name: :user, required?: false }
                  ],
                  validation: %i[at_least_one_of group user]
            end
            post do
              "bacon"
            end
          end
        end

        context "when all relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group, user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when non relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { nil }
          let(:status) { 400 }
          let(:body) do
            {
              "error" => "data[relationships] is missing, group, "\
                        "user are missing, at least one parameter must be provided"
            }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end

        context "when one relationships is provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end
      end

      describe "validates `exactly_one_of` relationships" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  relationships: [
                    { name: :group, required?: false },
                    { name: :user, required?: false }
                  ],
                  validation: %i[exactly_one_of group user]
            end
            post do
              "bacon"
            end
          end
        end

        context "when all relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group, user] }
          let(:status) { 400 }
          let(:body) { { "error" => "group, user are mutually exclusive" } }

          include_examples "renders proper status"
          include_examples "renders proper error"
        end

        context "when non relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { nil }
          let(:status) { 400 }
          let(:body) do
            {
              "error" => "data[relationships] is missing, group, user are missing, "\
                        "exactly one parameter must be provided"
            }
          end

          include_examples "renders proper status"
          include_examples "renders proper error"
        end

        context "when one relationships is provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end
      end

      describe "validates `mutually_exclusive` relationships" do
        before do
          subject.namespace do
            params do
              use :json_api_request,
                  relationships: [
                    { name: :group, required?: false },
                    { name: :user, required?: false }
                  ],
                  validation: %i[mutually_exclusive group user]
            end
            post do
              "bacon"
            end
          end
        end

        context "when all relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [group, user] }
          let(:status) { 400 }
          let(:body) { { "error" => "group, user are mutually exclusive" } }

          include_examples "renders proper status"
          include_examples "renders proper error"
        end

        context "when non relationships are provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { nil }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end

        context "when one relationships is provided" do
          let(:params) do
            json_api_params(
              type: "locations",
              relationships: relationships
            )
          end
          let(:relationships) { [user] }
          let(:status) { 201 }
          let(:body) { "bacon" }

          include_examples "renders proper status"
          include_examples "renders proper body"
        end
      end
    end
  end
end
