require "csv"

class CedictFilter
  def initialize
    @csv_rows = CSV.parse(File.read(source_csv_path), headers: true)
    @headers = csv_rows.headers

    characters_text = File.read(characters_text_path)
    @characters = characters_text.split("\n").map { |line| line.split("") }.flatten
  end

  def run
    filtered_rows = csv_rows.select do |csv_row|
      characters.include?(csv_row["simplified"])
    end

    final_rows = filtered_rows.each do |filtered_row|
      pinyin = filtered_row["pinyin-diacritic"]
      filtered_row["pinyin-diacritic"] = replace_diacritics(pinyin)
    end

    CSV.open(destination_csv_path, "wb") do |csv|
      csv << headers
      final_rows.each do |row|
        csv << row.fields
      end
    end

    true
  end

  private

  attr_reader :characters, :headers, :csv_rows

  def characters_text_path
    "./db/data/841.txt"
  end

  def destination_csv_path
    "./db/data/filtered_cedict.csv"
  end

  def source_csv_path
    "./tmp/cc-cedict-gdrive.csv"
  end

  def replace_diacritics(original_pinyin)
    return original_pinyin unless original_pinyin.match?("u:")

    final_pinyin = original_pinyin.dup

    diacritics_mapping.each do |a, b|
      final_pinyin.gsub!(a, b)
    end

    final_pinyin
  end

  def diacritics_mapping
    {
      "u:1" => "ǖ",
      "u:2" => "ǘ",
      "u:3" => "ǚ",
      "u:4" => "ǜ",
    }
  end
end
