# frozen_string_literal: true

class AddUtcToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :utc, :integer, null: false, default: 0
  end
end
