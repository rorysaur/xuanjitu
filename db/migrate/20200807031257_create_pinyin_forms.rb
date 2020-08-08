class CreatePinyinForms < ActiveRecord::Migration[6.0]
  def change
    create_table :pinyin_forms do |t|
      t.integer :character_id, null: false
      t.string :text_diacritic, null: false

      t.timestamps null: false
    end

    add_index :pinyin_forms, :character_id
  end
end
