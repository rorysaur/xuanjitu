class AddBlockNumberToReadings < ActiveRecord::Migration[6.0]
  def change
    add_column :readings, :block_number, :integer, null: false

    remove_index :readings, name: "index_readings_on_interpretation_and_color_and_number"
    add_index :readings, [:interpretation, :color, :block_number, :number], name: "index_readings_on_interpretation_block_and_number"
  end
end
