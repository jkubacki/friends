# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::ConfirmationMailer, type: :mailer do
  describe "notify" do
    let(:mail) { Users::ConfirmationMailer.send_confirmation(user.id) }

    let(:user) do
      create(
        :user, id: 1, email: "user@example.com", confirmation_token: "y_MnZqcxZtuYydoLzr3Y"
      )
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your account")
      expect(mail.to).to eq(["user@example.com"])
    end

    it "renders the body with link to token" do
      expect(mail.body.encoded).to match("confirmation_token=y_MnZqcxZtuYydoLzr3Y")
    end
  end
end
