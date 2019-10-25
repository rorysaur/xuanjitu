class AddRhymeToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :rhyme, :boolean, default: false
  end
end
