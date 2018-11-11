# frozen_string_literal: true

class SocialMediaProfile < ApplicationRecord
  belongs_to :user

  validates :user, :uid, :provider, presence: true
end
