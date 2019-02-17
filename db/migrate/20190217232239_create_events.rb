# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.belongs_to :group, foreign_key: true, null: false
      t.belongs_to :proposition, foreign_key: true, null: false
      t.datetime :date, null: false

      t.timestamps
    end
  end
end
