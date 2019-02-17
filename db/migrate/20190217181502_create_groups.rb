# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :meeting_length_in_minutes, null: false, default: 60
      t.boolean :creator_required, null: false, default: false
      t.integer :min_users_in_meeting, null: false, default: 0

      t.timestamps
    end
  end
end
