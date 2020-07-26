require "csv"

class ReadingSegmentAssignmentsGenerator
  def generate
    CSV.open(generated_csv_path, "wb") do |csv|
      csv << headers
      collected_attrs.each do |attrs|
        csv << attrs.values
      end
    end

    true
  end

  private

  def generated_csv_path
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
    green
  end

  def sample
    {
      color: "green",
      block_number: 1,
      reading_number: 1,
      head_y: 1,
      head_x: 6,
      line_number: 1,
      enabled: 1,
    }
  end

  def green
    starting_points = [
      { x: 1, y: 1, block_number: 1 },
      { x: 22, y: 1, block_number: 3 },
      { x: 22, y: 22, block_number: 5 },
      { x: 1, y: 22, block_number: 7 },
    ]
    rows = []

    starting_points.each do |attrs|
      rows << green_helper_long(reading_number: 1, ascending_rows: true, direction_mode: :reversed, **attrs)
      rows << green_helper_long(reading_number: 2, ascending_rows: false, direction_mode: :conventional, **attrs)
      rows << green_helper_long(reading_number: 3, ascending_rows: true, direction_mode: :conventional, **attrs)
      rows << green_helper_long(reading_number: 4, ascending_rows: false, direction_mode: :reversed, **attrs)
      rows << green_helper_long(reading_number: 5, from_center: true, ascending_rows: true, direction_mode: :reversed, **attrs)
      rows << green_helper_long(reading_number: 6, from_center: true, ascending_rows: false, direction_mode: :conventional, **attrs)
      rows << green_helper_long(reading_number: 7, from_center: true, ascending_rows: true, direction_mode: :conventional, **attrs)
      rows << green_helper_long(reading_number: 8, from_center: true, ascending_rows: false, direction_mode: :reversed, **attrs)

      rows << green_helper_short(reading_number: 9, side: :right, ascending_rows: true, snake: true, direction_mode: :reversed, **attrs)
      rows << green_helper_short(reading_number: 10, side: :right, ascending_rows: false, snake: true, direction_mode: :conventional, **attrs)
      rows << green_helper_short(reading_number: 11, side: :left, ascending_rows: true, snake: true, direction_mode: :conventional, **attrs)
      rows << green_helper_short(reading_number: 12, side: :left, ascending_rows: false, snake: true, direction_mode: :reversed, **attrs)
      rows << green_helper_short(reading_number: 13, side: :right, ascending_rows: true, snake: false, direction_mode: :conventional, **attrs)
      rows << green_helper_short(reading_number: 14, side: :right, ascending_rows: false, snake: false, direction_mode: :conventional, **attrs)
      rows << green_helper_short(reading_number: 15, side: :left, ascending_rows: true, snake: false, direction_mode: :reversed, **attrs)
      rows << green_helper_short(reading_number: 16, side: :left, ascending_rows: false, snake: false, direction_mode: :reversed, **attrs)

      rows << green_helper_alternating(reading_number: 17, ascending_rows: true, direction_mode: :reversed, **attrs)
      rows << green_helper_alternating(reading_number: 18, ascending_rows: false, direction_mode: :reversed, **attrs)
      rows << green_helper_alternating(reading_number: 19, ascending_rows: true, direction_mode: :conventional, **attrs)
      rows << green_helper_alternating(reading_number: 20, ascending_rows: false, direction_mode: :conventional, **attrs)
      rows << green_helper_alternating(reading_number: 21, ascending_rows: true, from_center: true, direction_mode: :reversed, **attrs)
      rows << green_helper_alternating(reading_number: 22, ascending_rows: true, from_center: true, direction_mode: :conventional, **attrs)
      rows << green_helper_alternating(reading_number: 23, ascending_rows: false, from_center: true, direction_mode: :conventional, **attrs)
      rows << green_helper_alternating(reading_number: 24, ascending_rows: false, from_center: true, direction_mode: :reversed, **attrs)
    end

    rows.flatten
  end

  def green_helper_long(reading_number:, from_center: false, ascending_rows:, direction_mode:, x:, y:, block_number:)
    line_length = 3
    num_steps = line_length - 1
    num_lines = 12
    num_rows = 6
    color = "green"

    left_min = x
    left_max = x + num_steps
    right_min = x + line_length
    right_max = x + line_length + num_steps

    if from_center
      left_to_right = [left_max, right_min]
      right_to_left = left_to_right.reverse
    else
      left_to_right = [x, right_min]
      right_to_left = [right_max, left_max]
    end

    row_indices = (0...num_rows).to_a
    row_indices = ascending_rows ? row_indices : row_indices.reverse

    results = []

    row_indices.each do |row_idx|
      diff = (row_idx * 2) + 1
      line_number1 = ascending_rows ? diff : (num_lines - diff)
      line_number2 = line_number1 + 1
      line_numbers = [line_number1, line_number2]

      head_x_coordinates =
        if direction_mode == :conventional # aka "evens start on left"
          row_idx.even? ? left_to_right : right_to_left
        elsif direction_mode == :reversed # aka "evens start on right"
          row_idx.even? ? right_to_left : left_to_right
        end

      (0..1).each do |i|
        csv_row = {
          color: color,
          block_number: block_number,
          reading_number: reading_number,
          head_y: y + row_idx,
          head_x: head_x_coordinates[i],
          line_number: line_numbers[i],
          enabled: 1,
        }

        results << csv_row
      end
    end

    results
  end

  def green_helper_short(reading_number:, ascending_rows:, snake:, direction_mode:, side:, x:, y:, block_number:)
    line_length = 3
    num_steps = line_length - 1
    num_lines = 6
    num_rows = 6
    color = "green"

    min_x =
      if side == :left
        x
      elsif side == :right
        x + line_length
      end

    max_x = min_x + num_steps

    row_indices = (0...num_rows).to_a
    row_indices = ascending_rows ? row_indices : row_indices.reverse

    results = []

    row_indices.each do |row_idx|
      line_number = ascending_rows ? (row_idx + 1) : (num_lines - row_idx)

      head_x =
        if direction_mode == :conventional
          if snake
            row_idx.even? ? min_x : max_x
          else
            min_x
          end
        elsif direction_mode == :reversed
          if snake
            row_idx.even? ? max_x : min_x
          else
            max_x
          end
        end

      csv_row = {
        color: color,
        block_number: block_number,
        reading_number: reading_number,
        head_y: y + row_idx,
        head_x: head_x,
        line_number: line_number,
        enabled: 1,
      }

      results << csv_row
    end

    results
  end

  def green_helper_alternating(reading_number:, ascending_rows:, from_center: false, direction_mode:, x:, y:, block_number:)
    line_length = 3
    num_steps = line_length - 1
    num_lines = 6
    num_rows = 6
    color = "green"

    left_min = x
    left_max = x + num_steps
    right_min = x + line_length
    right_max = x + line_length + num_steps

    row_indices = (0...num_rows).to_a
    row_indices = ascending_rows ? row_indices : row_indices.reverse

    results = []

    row_indices.each do |row_idx|
      line_number = ascending_rows ? (row_idx + 1) : (num_lines - row_idx)

      head_x =
        if from_center
          if direction_mode == :conventional # aka "evens on left"
            row_idx.even? ? left_max : right_min
          elsif direction_mode == :reversed # aka "evens on right"
            row_idx.even? ? right_min : left_max
          end
        else
          if direction_mode == :conventional # aka "read left to right"
            if ascending_rows
              row_idx.even? ? left_min : right_min
            else
              row_idx.even? ? right_min : left_min
            end
          elsif direction_mode == :reversed # aka "read right to left"
            if ascending_rows
              row_idx.even? ? right_max : left_max
            else
              row_idx.even? ? left_max : right_max
            end
          end
        end

      csv_row = {
        color: color,
        block_number: block_number,
        reading_number: reading_number,
        head_y: y + row_idx,
        head_x: head_x,
        line_number: line_number,
        enabled: 1,
      }

      results << csv_row
    end

    results
  end

  def black_horizontal
  end

  def black_vertical
  end

  def purple
  end

  def yellow_horizontal
  end

  def yellow_vertical
  end

  def yellow_center
  end

  def purple_center
  end
end
