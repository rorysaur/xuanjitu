class CreateCharacterSegmentAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :character_segment_assignments do |t|
      t.integer :character_id, null: false
      t.integer :segment_id, null: false

      t.timestamps null: false
    end

    add_index :character_segment_assignments, :character_id
    add_index :character_segment_assignments, :segment_id
  end
end
