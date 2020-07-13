class AddEnabledToReadings < ActiveRecord::Migration[6.0]
  def change
    add_column :readings, :enabled, :boolean, null: false, default: true
  end
end
