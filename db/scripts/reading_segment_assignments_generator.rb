require "csv"
require_relative "./reading_generator"

class ReadingSegmentAssignmentsGenerator
  def run
    generate
    diff_csvs
  end

  def generate
    CSV.open(new_generated_csv_path, "wb") do |csv|
      csv << headers
      collected_attrs.each do |attrs|
        csv << attrs.values
      end
    end

    true
  end

  def diff_csvs
    old_rows = CSV.parse(File.read(old_generated_csv_path), headers: true, converters: :integer).map(&:to_h)
    new_rows = CSV.parse(File.read(new_generated_csv_path), headers: true, converters: :integer).map(&:to_h)

    in_new_only = new_rows - old_rows
    in_old_only = old_rows - new_rows

    puts "in new only: #{in_new_only.size} rows"
    in_new_only.each do |row|
      p row
    end
    puts "in old only: #{in_old_only.size} rows"
    in_old_only.each do |row|
      p row
    end

    nil
  end

  private

  def old_generated_csv_path
    "./db/data/deprecated/old_generated_reading_segment_assignments.csv"
  end

  def new_generated_csv_path
    "./db/data/generated_reading_segment_assignments.csv"
  end

  def headers
    [
      "color",
      "block_number",
      "reading_number",
      "head_y",
      "head_x",
      "line_number",
      "enabled",
    ]
  end

  def collected_attrs
    results =
      green +
      black +
      yellow +
      purple +
      yellow_center +
      purple_center

    results
  end

  def green
    starting_points = [
      { x: 1, y: 1, block_number: 1 },
      { x: 22, y: 1, block_number: 3 },
      { x: 22, y: 22, block_number: 5 },
      { x: 1, y: 22, block_number: 7 },
    ]
    attr_sets = [
      {
        reading_number: 1,
        style: :long,
        ascending_order: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 2,
        style: :long,
        ascending_order: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 3,
        style: :long,
        ascending_order: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 4,
        style: :long,
        ascending_order: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 5,
        style: :long,
        ascending_order: true,
        direction_mode: :reversed,
        from_center: true,
      },
      {
        reading_number: 6,
        style: :long,
        ascending_order: false,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 7,
        style: :long,
        ascending_order: true,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 8,
        style: :long,
        ascending_order: false,
        direction_mode: :reversed,
        from_center: true,
      },
      {
        reading_number: 9,
        style: :short,
        snake: true,
        side: :right,
        ascending_order: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 10,
        style: :short,
        snake: true,
        side: :right,
        ascending_order: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 11,
        style: :short,
        snake: true,
        side: :left,
        ascending_order: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 12,
        style: :short,
        snake: true,
        side: :left,
        ascending_order: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 13,
        style: :short,
        snake: false,
        side: :right,
        ascending_order: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 14,
        style: :short,
        snake: false,
        side: :right,
        ascending_order: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 15,
        style: :short,
        snake: false,
        side: :left,
        ascending_order: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 16,
        style: :short,
        snake: false,
        side: :left,
        ascending_order: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 17,
        style: :alternating,
        ascending_order: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 18,
        style: :alternating,
        ascending_order: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 19,
        style: :alternating,
        ascending_order: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 20,
        style: :alternating,
        ascending_order: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 21,
        style: :alternating,
        ascending_order: true,
        direction_mode: :reversed,
        from_center: true,
      },
      {
        reading_number: 22,
        style: :alternating,
        ascending_order: true,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 23,
        style: :alternating,
        ascending_order: false,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 24,
        style: :alternating,
        ascending_order: false,
        direction_mode: :reversed,
        from_center: true,
      },
    ]
    rows = []

    starting_points.each do |starting_points_attrs|
      attr_sets.each do |attr_set|
        attrs = attr_set.merge(starting_points_attrs)

        rows << ReadingGeneratorGreen.new(attrs).generate
      end
    end

    rows.flatten
  end

  def black
    starting_points = [
      { x: 8, y: 1, block_number: 2 },
      { x: 22, y: 8, block_number: 4 },
      { x: 8, y: 22, block_number: 6 },
      { x: 1, y: 8, block_number: 8 },
    ]
    attr_sets = [
      {
        reading_number: 1,
        style: :short,
        ascending_order: true,
        direction_mode: :reversed,
        from_center: true,
      },
      {
        reading_number: 2,
        style: :short,
        ascending_order: false,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 3,
        style: :short,
        ascending_order: true,
        direction_mode: :conventional,
        from_center: true,
      },
      {
        reading_number: 4,
        style: :short,
        ascending_order: false,
        direction_mode: :reversed,
        from_center: true,
      },
      {
        reading_number: 5,
        style: :short,
        ascending_order: true,
        side: :right,
      },
      {
        reading_number: 6,
        style: :short,
        ascending_order: false,
        side: :right,
      },
      {
        reading_number: 7,
        style: :short,
        ascending_order: true,
        side: :left,
      },
      {
        reading_number: 8,
        style: :short,
        ascending_order: false,
        side: :left,
      },
      {
        reading_number: 9,
        style: :long,
        ascending_order: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 10,
        style: :long,
        ascending_order: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 11,
        style: :long,
        ascending_order: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 12,
        style: :long,
        ascending_order: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 13,
        style: :long,
        ascending_order: true,
        direction_mode: :reversed,
        by_couplet: true,
      },
      {
        reading_number: 14,
        style: :long,
        ascending_order: true,
        direction_mode: :conventional,
        by_couplet: true,
      },
      {
        reading_number: 15,
        style: :long,
        ascending_order: false,
        direction_mode: :reversed,
        by_couplet: true,
      },
      {
        reading_number: 16,
        style: :long,
        ascending_order: false,
        direction_mode: :conventional,
        by_couplet: true,
      },
    ]
    rows = []

    starting_points.each do |starting_points_attrs|
      orientation = (starting_points_attrs[:block_number] % 4 == 0) ? :vertical : :horizontal

      mapped_attr_sets =
        if orientation == :horizontal
          attr_sets
        elsif orientation == :vertical
          attr_sets.map do |attr_set|
            mappings = {
              conventional: :reversed,
              reversed: :conventional,
              left: :lower,
              right: :upper,
            }
            duped = attr_set.clone
            duped[:direction_mode] = mappings[attr_set[:direction_mode]]
            duped[:side] = mappings[attr_set[:side]]

            duped
          end
        end

      mapped_attr_sets.each do |attr_set|
        attrs = attr_set.merge(starting_points_attrs)

        rows << ReadingGeneratorBlack.new(orientation: orientation, **attrs).generate
      end
    end

    rows.flatten
  end

  def yellow
    starting_points = [
      { x: 12, y: 8, block_number: 10 },
      { x: 17, y: 12, block_number: 12 },
      { x: 12, y: 17, block_number: 14 },
      { x: 8, y: 12, block_number: 16 },
    ]
    attr_sets = [
      {
        reading_number: 1,
        line_numbers: [1, 2, 3, 4],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 2,
        line_numbers: [1, 2, 3, 4],
        snake: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 3,
        line_numbers: [4, 3, 2, 1],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 4,
        line_numbers: [4, 3, 2, 1],
        snake: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 5,
        line_numbers: [1, 2, 3, 4],
        snake: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 6,
        line_numbers: [4, 3, 2, 1],
        snake: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 7,
        line_numbers: [1, 2, 3, 4],
        snake: true,
        direction_mode: :reversed,
      },
      {
        reading_number: 8,
        line_numbers: [4, 3, 2, 1],
        snake: true,
        direction_mode: :conventional,
      },
      {
        reading_number: 9,
        line_numbers: [1, 4, 3, 2],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 10,
        line_numbers: [2, 3, 4, 1],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 11,
        line_numbers: [1, 4, 3, 2],
        snake: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 12,
        line_numbers: [2, 3, 4, 1],
        snake: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 13,
        line_numbers: [4, 1, 2, 3],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 14,
        line_numbers: [3, 2, 1, 4],
        snake: false,
        direction_mode: :conventional,
      },
      {
        reading_number: 15,
        line_numbers: [4, 1, 2, 3],
        snake: false,
        direction_mode: :reversed,
      },
      {
        reading_number: 16,
        line_numbers: [3, 2, 1, 4],
        snake: false,
        direction_mode: :reversed,
      },
    ]

    rows = []

    starting_points.each do |starting_points_attrs|
      attr_sets.each do |attr_set|
        attrs = attr_set.merge(starting_points_attrs)

        rows << ReadingGeneratorYellow.new(attrs).generate
      end
    end

    rows.flatten
  end

  def purple
    starting_points = [
      { x: 8, y: 8, block_number: 9 },
      { x: 17, y: 8, block_number: 11 },
      { x: 17, y: 17, block_number: 13 },
      { x: 8, y: 17, block_number: 15 },
    ]
    reading_number_to_line_numbers = {
      3 => [1, 2, 3, 4],
      4 => [4, 3, 2, 1],
      5 => [1, 4, 3, 2],
      6 => [2, 3, 4, 1],
      7 => [4, 1, 2, 3],
      8 => [3, 2, 1, 4],
      9 => [2, 1, 4, 3],
      10 => [3, 4, 1, 2],
    }
    rows = []

    starting_points.each do |starting_points_attrs|
      rows << ReadingGeneratorPurple.new(reading_number: 1, line_numbers: [1, 2, 3, 4], snake: true, direction_mode: :reversed, **starting_points_attrs).generate
      rows << ReadingGeneratorPurple.new(reading_number: 2, line_numbers: [4, 3, 2, 1], snake: true, direction_mode: :conventional, **starting_points_attrs).generate

      reading_number_to_line_numbers.each do |reading_number, line_numbers|
        rows << ReadingGeneratorPurple.new(reading_number: reading_number, line_numbers: line_numbers, **starting_points_attrs).generate
      end
    end

    rows.flatten
  end

  def yellow_center
    starting_points = [
      { x: 12, y: 12, block_number: 17 },
      { x: 16, y: 12, block_number: 17 },
      { x: 16, y: 16, block_number: 17 },
      { x: 12, y: 16, block_number: 17 },
    ]
    color = "yellow"

    rows = []

    4.times do |reading_idx|
      reading_number = reading_idx + 1

      starting_points.rotate(reading_idx).each_with_index do |attrs, line_idx|
        csv_row = {
          color: color,
          block_number: attrs[:block_number],
          reading_number: reading_number,
          head_y: attrs[:y],
          head_x: attrs[:x],
          line_number: line_idx + 1,
          enabled: 1,
        }

        rows << csv_row
      end

    end

    rows
  end

  def purple_center
    head_coordinates = [
      { x: 14, y: 13 },
      { x: 13, y: 14 },
      { x: 15, y: 13 },
      { x: 15, y: 15 },
    ]
    color = "purple"
    block_number = 18
    reading_number = 1

    rows = []

    head_coordinates.each_with_index do |attrs, line_idx|
      csv_row = {
        color: color,
        block_number: block_number,
        reading_number: reading_number,
        head_y: attrs[:y],
        head_x: attrs[:x],
        line_number: line_idx + 1,
        enabled: 1,
      }

      rows << csv_row
    end

    rows
  end
end
