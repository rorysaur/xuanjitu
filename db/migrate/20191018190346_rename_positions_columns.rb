class RenamePositionsColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :positions, :x, :x_coordinate
    rename_column :positions, :y, :y_coordinate
  end
end
