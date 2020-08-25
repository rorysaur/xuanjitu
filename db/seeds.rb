require "csv"

# seed positions if table is empty
if Position.none?
  # prepare color values
  csv_path = File.join(Rails.root, "db", "data", "colors-metail.csv")
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
if Character.none?
  # read characters file
  file_path = File.join(Rails.root, "db", "data", "841.txt")
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

# seed segments if table is empty
if Segment.none?
  segments_csv_path = File.join(Rails.root, "db", "data", "generated_segments.csv")
  segment_rows = CSV.parse(File.read(segments_csv_path), headers: true, converters: :integer)

  ActiveRecord::Base.transaction do
    segment_rows.each do |segment_row|
      head_position = Position.find_by!(
        x_coordinate: segment_row["head_x"],
        y_coordinate: segment_row["head_y"],
      )
      tail_position = Position.find_by!(
        x_coordinate: segment_row["tail_x"],
        y_coordinate: segment_row["tail_y"],
      )
      Segment.create!(
        head_position: head_position,
        tail_position: tail_position,
        length: segment_row["length"],
        color: segment_row["color"],
      )
    end
  end
else
  puts "#{Segment.count} segments already exist!"
end

# seed character_segment_assignments if table is empty
if CharacterSegmentAssignment.none?
  segments = Segment.includes(:head_position, :tail_position).all
  characters = Character.includes(:position).all

  ActiveRecord::Base.transaction do
    characters.each do |char|
      segments.where(color: char.color).each do |segment|
        next unless char.position.between?(segment.head_position, segment.tail_position)

        CharacterSegmentAssignment.create!(
          character: char,
          segment: segment,
        )
      end
    end
  end
else
  puts "#{CharacterSegmentAssignment.count} character_segment_assignments already exist!"
end

if ReadingSegmentAssignment.none?
  reading_segment_assignments_csv_path = File.join(Rails.root, "db", "data", "generated_reading_segment_assignments.csv")
  rows = CSV.parse(File.read(reading_segment_assignments_csv_path), headers: true, converters: :integer)

  ActiveRecord::Base.transaction do
    rows.each do |row|
      reading = Reading.find_or_create_by!(
        interpretation: 0, # hard-coding for now
        color: row["color"],
        block_number: row["block_number"],
        number: row["reading_number"],
        enabled: row["enabled"],
      )

      head_position = Position.find_by!(
        x_coordinate: row["head_x"],
        y_coordinate: row["head_y"],
      )

      segment = Segment.find_by!(
        head_position_id: head_position.id,
        color: row["color"],
      )

      ReadingSegmentAssignment.create!(
        reading: reading,
        segment: segment,
        line_number: row["line_number"],
      )
    end
  end
end
