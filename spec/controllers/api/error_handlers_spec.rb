# frozen_string_literal: true

require "rails_helper"

describe API::ErrorHandlers do
  include Rack::Test::Methods

  subject do
    module API
      def self.set(dynamic_name)
        @@dynamic_name = dynamic_name
      end
    end

    API.set(dynamic_name)

    module API
      Object.const_set(
        @@dynamic_name,
        Class.new(Grape::API) do
          helpers V1::Helpers::JSONAPIHelpers
          include ErrorHandlers
          format :json
        end
      )
    end
  end

  def app
    subject
  end

  let(:dynamic_name) do
    hex = SecureRandom.hex(5)
    "Helpers#{hex}"
  end

  shared_context "when violating uniqueness constraint" do
    let(:status) { 409 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "(from_with_datetime, to_with_datetime, opportunity_id)",
            "detail" => "PG::UniqueViolation: duplicate entry for (from_with_datetime, "\
                        "to_with_datetime, opportunity_id) violates unique constraint",
            "code" => "taken",
            "status" => status
          }
        ]
      }
    end
  end

  shared_examples "renders proper status" do
    it "renders proper status" do
      post "/"
      expect(last_response.status).to eq status
    end
  end

  shared_examples "renders proper error" do
    it "renders proper error" do
      post "/"
      expect(last_response_body).to eq error
    end
  end

  describe "rescue_from ActiveRecord::RecordNotFound" do
    before do
      subject.namespace do
        post do
          raise ActiveRecord::RecordNotFound
        end
      end
    end

    let(:status) { 404 }
    let(:error) do
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

  describe "rescue_from ActiveRecord::RecordInvalid" do
    before do
      subject.namespace do
        post do
          user = User.new(email: "abc")
          user.valid?
          raise ActiveRecord::RecordInvalid, user
        end
      end
    end

    let(:status) { 422 }
    let(:error) do
      {
        "error" => [
          {
            "code" => "invalid",
            "detail" => "Email is invalid",
            "status" => 422,
            "title" => "email"
          },
          {
            "code" => "blank",
            "detail" => "Password can't be blank",
            "status" => 422,
            "title" => "password"
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end

  describe "rescue_from all" do
    before do
      subject.namespace do
        post do
          raise StandardError
        end
      end
    end

    let(:status) { 500 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "StandardError",
            "detail" => nil,
            "code" => "standarderror",
            "status" => status
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end

  describe "rescue_from ActiveRecord::InvalidForeignKey" do
    before do
      subject.namespace do
        post do
          raise ActiveRecord::InvalidForeignKey
        end
      end
    end

    let(:status) { 500 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "Invalid Foreign Key",
            "detail" => nil,
            "code" => "invalid_foreign_key",
            "status" => status
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end

  describe "rescue_from Grape::Exceptions::ValidationErrors" do
    before do
      subject.namespace do
        post do
          raise Grape::Exceptions::ValidationErrors
        end
      end
    end

    let(:status) { 400 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "",
            "detail" => nil,
            "code" => "",
            "status" => status
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end

  describe "rescue_from Pundit::NotAuthorizedError" do
    before do
      subject.namespace do
        post do
          raise Pundit::NotAuthorizedError, "Forbidden"
        end
      end
    end

    let(:status) { 403 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "Forbidden",
            "detail" => nil,
            "code" => "forbidden",
            "status" => status
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end

  describe "rescue_from Pundit::AuthorizationNotPerformedError" do
    before do
      subject.namespace do
        post do
          raise Pundit::AuthorizationNotPerformedError, "error message"
        end
      end
    end

    let(:status) { 500 }
    let(:error) do
      {
        "errors" => [
          {
            "title" => "Authorization Not Performed",
            "detail" => nil,
            "code" => "authorization_not_performed",
            "status" => status
          }
        ]
      }
    end

    include_examples "renders proper status"
    include_examples "renders proper error"
  end
end
