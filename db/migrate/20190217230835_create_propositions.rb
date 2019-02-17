# frozen_string_literal: true

class CreatePropositions < ActiveRecord::Migration[5.2]
  def change
    create_table :propositions do |t|
      t.belongs_to :group, foreign_key: true, null: false
      t.datetime :date, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
