class CreateReadingSegmentAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :reading_segment_assignments do |t|
      t.integer :reading_id, null: false
      t.integer :segment_id, null: false
      t.integer :line_number, null: false

      t.timestamps null: false
    end

    add_index :reading_segment_assignments, :reading_id
    add_index :reading_segment_assignments, :segment_id
  end
end
