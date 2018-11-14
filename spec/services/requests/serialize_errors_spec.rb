# frozen_string_literal: true

require "rails_helper"

describe Requests::SerializeErrors do
  shared_examples "returns success result object" do
    it "returns success result" do
      expect(subject.success?).to be true
    end

    it "returns serialized errors" do
      expect(subject.value!).to eq(errors)
    end
  end

  describe ".call" do
    subject { described_class.call(messages: messages, details: details, status: status) }

    context "when only one message is passed" do
      let(:details) { { password_confirmation: [{ error: :confirmation, attribute: "Password" }] } }
      let(:messages) { { password_confirmation: ["doesn't match Password"] } }
      let(:status) { 422 }
      let(:errors) do
        [
          {
            title: "password_confirmation",
            detail: "Password confirmation doesn't match Password",
            code: "confirmation",
            status: 422
          }
        ]
      end

      include_examples "returns success result object"
    end

    context "when multiple messages are passed" do
      let(:details) do
        {
          password_confirmation: [{ error: :confirmation, attribute: "Password" }],
          password: [{ error: :too_short, count: 6 }]
        }
      end
      let(:messages) do
        {
          password_confirmation: ["doesn't match Password"],
          password: ["is too short (minimum is 6 characters)"]
        }
      end
      let(:status) { 422 }
      let(:errors) do
        [
          {
            title: "password_confirmation",
            detail: "Password confirmation doesn't match Password",
            code: "confirmation",
            status: 422
          },
          {
            title: "password",
            detail: "Password is too short (minimum is 6 characters)",
            code: "too_short",
            status: 422
          }
        ]
      end

      include_examples "returns success result object"
    end

    context "when one key has many messages" do
      let(:details) do
        {
          password: [{ error: :too_short, count: 6 }, { error: :same_as_current }]
        }
      end
      let(:messages) do
        {
          password: ["is too short (minimum is 6 characters)", "is the same as current password"]
        }
      end
      let(:status) { 422 }
      let(:errors) do
        [
          {
            title: "password",
            detail: "Password is too short (minimum is 6 characters)",
            code: "too_short",
            status: 422
          },
          {
            title: "password",
            detail: "Password is the same as current password",
            code: "same_as_current",
            status: 422
          }
        ]
      end

      include_examples "returns success result object"
    end
  end
end
