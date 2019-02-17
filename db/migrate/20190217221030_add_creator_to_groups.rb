# frozen_string_literal: true

class AddCreatorToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :creator, foreign_key: { to_table: :users }
  end
end
