# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :social_media_profiles

  validates :utc, presence: true

  def send_confirmation_notification?
    false # don't send a default confirmation email
  end
end
