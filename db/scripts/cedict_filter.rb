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

    CSV.open(destination_csv_path, "wb") do |csv|
      csv << headers
      filtered_rows.each do |row|
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
end
