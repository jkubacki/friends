# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::ConfirmationsPolicy do
  subject { described_class }

  permissions :create? do
    it "permits not logged in users" do
      expect(subject).to permit(nil, described_class, :create?)
    end
  end
end
