# frozen_string_literal: true

class CreateSocialMediaProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :social_media_profiles do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
