require "csv"

# seed positions if table is empty
if !Position.any?
  # prepare color values
  csv_path = File.join(Rails.root, "db", "data", "colors.csv")
  CSV::Converters[:symbol] = -> (value) { value.to_sym }
  colors = CSV.parse(File.read(csv_path), headers: true, converters: :symbol)
  color_mappings = {
    a: "black",
    u: "blue",
    g: "green",
    p: "purple",
    r: "red",
    y: "yellow",
  }

  ActiveRecord::Base.transaction do
    (0..28).each do |y|
      (0..28).each do |x|
        color_key = colors[y][x]
        color = color_mappings[color_key]
        raise "color for #{color_key} not found at (#{x},#{y})!" if color.nil?

        Position.create!(
          x_coordinate: x,
          y_coordinate: y,
          color: color,
        )
      end
    end
  end
else
  puts "#{Position.count} positions already exist!"
end

# seed characters if table is empty
if !Character.any?
  file_path = File.join(Rails.root, "db", "data", "characters.txt")
  text = File.read(file_path)

  ActiveRecord::Base.transaction do
    lines = text.split("\n")
    lines.each_with_index do |line, line_idx|
      characters = line.split("")
      characters.each_with_index do |char, char_idx|
        position = Position.find_by!(
          x_coordinate: char_idx,
          y_coordinate: line_idx,
        )

        Character.create!(
          text: char,
          form: Character.forms[:simplified],
          position: position,
        )
      end
    end
  end
else
  puts "#{Character.count} characters already exist!"
end
