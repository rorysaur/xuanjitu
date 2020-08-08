require "csv"

namespace :pinyin_forms do
  task populate: :environment do
    cedict_path = File.join(Rails.root, "db", "data", "filtered_cedict.csv")
    pinyin_csv = CSV.parse(File.read(cedict_path), headers: true)

    pinyin_mappings = {}

    pinyin_csv.each do |row|
      char = row["simplified"]
      pinyin = row["pinyin-diacritic"]

      if pinyin_mappings[char].nil?
        pinyin_mappings[char] = [pinyin]
      else
        pinyin_mappings[char] << pinyin
      end
    end

    ActiveRecord::Base.transaction do
      PinyinForm.delete_all

      Character.all.each do |character|
        puts "no pinyin found for #{character.text}" if pinyin_mappings[character.text].nil?

        pinyin_mappings[character.text].each do |pinyin|
          PinyinForm.create!(
            character: character,
            text_diacritic: pinyin,
          )
        end
      end
    end
  end
end
