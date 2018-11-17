# frozen_string_literal: true

require "rails_helper"

describe UserResource, type: :resource do
  subject { described_class.new(user, context) }

  let(:context) { {} }
  let(:user) { build_stubbed(:user) }

  describe "context based attributes" do
    context "when context is users/me endpoint" do
      let(:context) { { endpoint: "users/me" } }

      it { is_expected.to have_attribute(:email) }
    end

    context "when context is not users/me endpoint" do
      it { is_expected.not_to have_attribute(:email) }
    end
  end
end
