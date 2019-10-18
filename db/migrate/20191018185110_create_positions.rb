class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.integer :x, null: false
      t.integer :y, null: false

      t.timestamps null: false
    end

    add_index :positions, [:x, :y]
  end
end
