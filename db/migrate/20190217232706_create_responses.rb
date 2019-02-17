# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.belongs_to :proposition, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.boolean :confirmed, null: false, default: false

      t.timestamps
    end
  end
end
