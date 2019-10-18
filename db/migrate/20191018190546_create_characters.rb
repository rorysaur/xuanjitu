class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :text, null: false
      t.string :form, null: false
      t.integer :position_id, null: false
    end

    add_index :characters, :position_id
  end
end
