class CreateReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.string :color, null: false
      t.integer :number, null: false
      t.integer :interpretation, null: false

      t.timestamps null: false
    end

    add_index :readings, [:interpretation, :color, :number]
  end
end
