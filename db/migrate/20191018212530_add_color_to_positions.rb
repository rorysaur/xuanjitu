class AddColorToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :color, :string
    add_index :positions, :color
  end
end
