# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class }

  permissions :create? do
    it "permits not logged in users" do
      expect(subject).to permit(nil, described_class, :create?)
    end
  end

  permissions :me? do
    let(:record) { build_stubbed(:user) }

    context "when user is not the same as record" do
      let(:user) { build_stubbed(:user) }

      it "denies access if post is published" do
        expect(subject).not_to permit(user, record)
      end
    end

    context "when user is the same as record" do
      let(:user) { record }

      it "denies access if post is published" do
        expect(subject).to permit(user, record)
      end
    end
  end
end
