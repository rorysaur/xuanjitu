class CreateSegments < ActiveRecord::Migration[6.0]
  def change
    create_table :segments do |t|
      t.integer :head_position_id, null: false
      t.integer :tail_position_id, null: false
      t.integer :length, null: false
      t.string :color, null: false

      t.timestamps null: false
    end

    add_index :segments, :head_position_id
    add_index :segments, :tail_position_id
  end
end
