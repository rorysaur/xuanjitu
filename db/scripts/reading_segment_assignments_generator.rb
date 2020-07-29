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
    black
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
    left_max = left_min + num_steps
    right_min = x + line_length
    right_max = right_min + num_steps

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
    left_max = left_min + num_steps
    right_min = x + line_length
    right_max = right_min + num_steps

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

  def black
    starting_points = [
      { x: 8, y: 1, block_number: 2 },
      { x: 22, y: 8, block_number: 4 },
      { x: 8, y: 22, block_number: 6 },
      { x: 1, y: 8, block_number: 8 },
    ]
    rows = []

    starting_points.each do |attrs|
      orientation = (attrs[:block_number] % 4 == 0) ? :vertical : :horizontal

      if orientation == :horizontal
        rows << black_horizontal_short(reading_number: 1, ascending_rows: true, from_center: true, direction_mode: :reversed, **attrs)
        rows << black_horizontal_short(reading_number: 2, ascending_rows: false, from_center: true, direction_mode: :conventional, **attrs)
        rows << black_horizontal_short(reading_number: 3, ascending_rows: true, from_center: true, direction_mode: :conventional, **attrs)
        rows << black_horizontal_short(reading_number: 4, ascending_rows: false, from_center: true, direction_mode: :reversed, **attrs)

        rows << black_horizontal_short(reading_number: 5, ascending_rows: true, side: :right, **attrs)
        rows << black_horizontal_short(reading_number: 6, ascending_rows: false, side: :right, **attrs)
        rows << black_horizontal_short(reading_number: 7, ascending_rows: true, side: :left, **attrs)
        rows << black_horizontal_short(reading_number: 8, ascending_rows: false, side: :left, **attrs)

        rows << black_horizontal_long(reading_number: 9, ascending_rows: true, direction_mode: :reversed, **attrs)
        rows << black_horizontal_long(reading_number: 10, ascending_rows: false, direction_mode: :conventional, **attrs)
        rows << black_horizontal_long(reading_number: 11, ascending_rows: true, direction_mode: :conventional, **attrs)
        rows << black_horizontal_long(reading_number: 12, ascending_rows: false, direction_mode: :reversed, **attrs)

        rows << black_horizontal_long(reading_number: 13, ascending_rows: true, by_couplet: true, direction_mode: :reversed, **attrs)
        rows << black_horizontal_long(reading_number: 14, ascending_rows: true, by_couplet: true, direction_mode: :conventional, **attrs)
        rows << black_horizontal_long(reading_number: 15, ascending_rows: false, by_couplet: true, direction_mode: :reversed, **attrs)
        rows << black_horizontal_long(reading_number: 16, ascending_rows: false, by_couplet: true, direction_mode: :conventional, **attrs)
      elsif orientation == :vertical
        rows << black_vertical_short(reading_number: 1, ascending_cols: true, from_center: true, direction_mode: :conventional, **attrs)
        rows << black_vertical_short(reading_number: 2, ascending_cols: false, from_center: true, direction_mode: :reversed, **attrs)
        rows << black_vertical_short(reading_number: 3, ascending_cols: true, from_center: true, direction_mode: :reversed, **attrs)
        rows << black_vertical_short(reading_number: 4, ascending_cols: false, from_center: true, direction_mode: :conventional, **attrs)

        rows << black_vertical_short(reading_number: 5, ascending_cols: true, side: :upper, **attrs)
        rows << black_vertical_short(reading_number: 6, ascending_cols: false, side: :upper, **attrs)
        rows << black_vertical_short(reading_number: 7, ascending_cols: true, side: :lower, **attrs)
        rows << black_vertical_short(reading_number: 8, ascending_cols: false, side: :lower, **attrs)

        rows << black_vertical_long(reading_number: 9, ascending_cols: true, direction_mode: :conventional, **attrs)
        rows << black_vertical_long(reading_number: 10, ascending_cols: false, direction_mode: :reversed, **attrs)
        rows << black_vertical_long(reading_number: 11, ascending_cols: true, direction_mode: :reversed, **attrs)
        rows << black_vertical_long(reading_number: 12, ascending_cols: false, direction_mode: :conventional, **attrs)

        rows << black_vertical_long(reading_number: 13, ascending_cols: true, by_couplet: true, direction_mode: :conventional, **attrs)
        rows << black_vertical_long(reading_number: 14, ascending_cols: true, by_couplet: true, direction_mode: :reversed, **attrs)
        rows << black_vertical_long(reading_number: 15, ascending_cols: false, by_couplet: true, direction_mode: :conventional, **attrs)
        rows << black_vertical_long(reading_number: 16, ascending_cols: false, by_couplet: true, direction_mode: :reversed, **attrs)
      end
    end

    rows.flatten
  end

  def black_vertical_short(reading_number:, ascending_cols:, from_center: false, side: nil, direction_mode: nil, x:, y:, block_number:)
    raise "you need to specify a direction_mode" if from_center && direction_mode.nil?
    raise "you need to specify a side" if !from_center && side.nil?

    line_length = 6
    num_steps = line_length - 1
    num_lines = 6
    num_cols = 6
    color = "black"

    upper_min = y
    upper_max = upper_min + num_steps
    lower_min = y + line_length + 1
    lower_max = lower_min + num_steps

    col_indices = (0...num_cols).to_a
    col_indices = ascending_cols ? col_indices : col_indices.reverse

    results = []

    col_indices.each do |col_idx|
      line_number = ascending_cols ? (col_idx + 1) : (num_lines - col_idx)

      head_y =
        if from_center
          if direction_mode == :conventional # aka "evens in upper block"
            col_idx.even? ? upper_max : lower_min
          elsif direction_mode == :reversed # aka "evens in lower block"
            col_idx.even? ? lower_min : upper_max
          end
        else
          if side == :upper
            upper_max
          elsif side == :lower
            lower_min
          end
        end

      csv_row = {
        color: color,
        block_number: block_number,
        reading_number: reading_number,
        head_y: head_y,
        head_x: x + col_idx,
        line_number: line_number,
        enabled: 1,
      }

      results << csv_row
    end

    results
  end

  def black_vertical_long(reading_number:, ascending_cols:, direction_mode:, by_couplet: false, x:, y:, block_number:)
    line_length = 6
    num_steps = line_length - 1
    num_lines = 12
    num_cols = 6
    color = "black"

    upper_min = y
    upper_max = upper_min + num_steps
    lower_min = y + line_length + 1
    lower_max = lower_min + num_steps

    upper_to_lower = [upper_max, lower_min]
    lower_to_upper = upper_to_lower.reverse

    col_indices = (0...num_cols).to_a
    col_indices = ascending_cols ? col_indices : col_indices.reverse

    results = []

    col_indices.each do |col_idx|
      if by_couplet
        if ascending_cols
          even_col = (col_idx * 2) + 1
          odd_col = col_idx * 2
        else
          even_col = num_lines - ((col_idx * 2) + 2)
          odd_col = num_lines - ((col_idx * 2) + 1)
        end

        line_number1 = col_idx.even? ? even_col : odd_col
        line_number2 = line_number1 + 2
      else
        diff = (col_idx * 2) + 1
        line_number1 = ascending_cols ? diff : (num_lines - diff)
        line_number2 = line_number1 + 1
      end

      line_numbers = [line_number1, line_number2]

      head_y_coordinates =
        if direction_mode == :conventional # aka "evens start in upper block"
          upper_to_lower
        elsif direction_mode == :reversed # aka "evens start in lower block"
          lower_to_upper
        end

      (0..1).each do |i|
        csv_row = {
          color: color,
          block_number: block_number,
          reading_number: reading_number,
          head_y: head_y_coordinates[i],
          head_x: x + col_idx,
          line_number: line_numbers[i],
          enabled: 1,
        }

        results << csv_row
      end
    end

    results
  end

  def black_horizontal_short(reading_number:, ascending_rows:, from_center: false, side: nil, direction_mode: nil, x:, y:, block_number:)
    raise "you need to specify a direction_mode" if from_center && direction_mode.nil?
    raise "you need to specify a side" if !from_center && side.nil?

    line_length = 6
    num_steps = line_length - 1
    num_lines = 6
    num_rows = 6
    color = "black"

    left_min = x
    left_max = left_min + num_steps
    right_min = x + line_length + 1
    right_max = right_min + num_steps

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
          if side == :left
            left_max
          elsif side == :right
            right_min
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

  def black_horizontal_long(reading_number:, ascending_rows:, direction_mode:, by_couplet: false, x:, y:, block_number:)
    line_length = 6
    num_steps = line_length - 1
    num_lines = 12
    num_rows = 6
    color = "black"

    left_min = x
    left_max = left_min + num_steps
    right_min = x + line_length + 1
    right_max = right_min + num_steps

    left_to_right = [left_max, right_min]
    right_to_left = left_to_right.reverse

    row_indices = (0...num_rows).to_a
    row_indices = ascending_rows ? row_indices : row_indices.reverse

    results = []

    row_indices.each do |row_idx|
      if by_couplet
        if ascending_rows
          even_row = (row_idx * 2) + 1
          odd_row = row_idx * 2
        else
          even_row = num_lines - ((row_idx * 2) + 2)
          odd_row = num_lines - ((row_idx * 2) + 1)
        end

        line_number1 = row_idx.even? ? even_row : odd_row
        line_number2 = line_number1 + 2
      else
        diff = (row_idx * 2) + 1
        line_number1 = ascending_rows ? diff : (num_lines - diff)
        line_number2 = line_number1 + 1
      end

      line_numbers = [line_number1, line_number2]

      head_x_coordinates =
        if direction_mode == :conventional # aka "evens start on left"
          left_to_right
        elsif direction_mode == :reversed # aka "evens start on right"
          right_to_left
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
