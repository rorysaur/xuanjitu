require "csv"

class SegmentsGenerator
  def generate
    CSV.open(generated_csv_path, "wb") do |csv|
      csv << headers
      collected_segments.each do |segments|
        csv << segments.values
      end
    end
  end

  def diff_csvs
    segments_csv_path = "./db/data/segments.csv"
    manual_rows = CSV.parse(File.read(segments_csv_path), headers: true, converters: :integer).map(&:to_h)
    generated_rows = CSV.parse(File.read(generated_csv_path), headers: true, converters: :integer).map(&:to_h)

    in_generated_only = generated_rows - manual_rows
    in_manual_only = manual_rows - generated_rows

    puts "in generated only: #{in_generated_only.size} rows"
    in_generated_only.each do |row|
      p row
    end
    puts "in manual only: #{in_manual_only.size} rows"
    in_manual_only.each do |row|
      p row
    end

    nil
  end

  private

  def generated_csv_path
    "./db/data/generated_segments.csv"
  end

  def headers
    [
      "head_x",
      "head_y",
      "tail_x",
      "tail_y",
      "color",
      "length",
    ]
  end

  def collected_segments
    all_segments =
      red +
      green +
      black_horizontal +
      black_vertical +
      purple +
      purple_center +
      yellow_horizontal +
      yellow_vertical +
      yellow_center

    all_segments
  end

  def red
    tail_coordinates = [0, 7, 14, 21, 28]
    length = 7
    num_steps = length - 1
    segments = []

    # right to left
    tail_coordinates.each do |y|
      tail_coordinates[0...-1].each do |x|
        next if (y == 14) && [7, 14].include?(x)

        segment = {
          head_x: x + num_steps,
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        segments << segment
      end
    end

    # left to right
    tail_coordinates.each do |y|
      tail_coordinates[1..-1].each do |x|
        next if (y == 14) && [14, 21].include?(x)

        segment = {
          head_x: x - num_steps,
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        segments << segment
      end
    end

    # bottom to top
    tail_coordinates[0...-1].each do |y|
      tail_coordinates.each do |x|
        next if (x == 14) && [7, 14].include?(y)

        segment = {
          head_x: x,
          head_y: y + num_steps,
          tail_x: x,
          tail_y: y,
        }

        segments << segment
      end
    end

    # top to bottom
    tail_coordinates[1..-1].each do |y|
      tail_coordinates.each do |x|
        next if (x == 14) && [14, 21].include?(y)

        segment = {
          head_x: x,
          head_y: y - num_steps,
          tail_x: x,
          tail_y: y,
        }

        segments << segment
      end
    end

    segments.map do |segment|
      segment[:color] = "red"
      segment[:length] = length

      segment
    end
  end

  def green
    starting_points = [
      { x: 1, y: 1 },
      { x: 22, y: 1 },
      { x: 22, y: 22 },
      { x: 1, y: 22 },
    ]
    length = 3
    num_steps = length - 1
    num_rows = 6
    segments = []

    starting_points.each do |coords|
      x, start_y = coords[:x], coords[:y]

      num_rows.times do |row_idx|
        y = start_y + row_idx

        left_segment = {
          head_x: x,
          head_y: y,
          tail_x: x + num_steps,
          tail_y: y,
        }

        left_segment_reversed = {
          head_x: left_segment[:tail_x],
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        right_segment = {
          head_x: x + length,
          head_y: y,
          tail_x: x + length + num_steps,
          tail_y: y,
        }

        right_segment_reversed = {
          head_x: right_segment[:tail_x],
          head_y: y,
          tail_x: right_segment[:head_x],
          tail_y: y,
        }

        segments += [left_segment, left_segment_reversed, right_segment, right_segment_reversed]
      end
    end

    segments.map do |segment|
      segment[:color] = "green"
      segment[:length] = length

      segment
    end
  end

  def black_horizontal
    starting_points = [
      { x: 8, y: 1 },
      { x: 8, y: 22 },
    ]
    length = 6
    num_steps = length - 1
    num_rows = 6
    segments = []

    starting_points.each do |coords|
      x, start_y = coords[:x], coords[:y]

      num_rows.times do |row_idx|
        y = start_y + row_idx

        left_segment = {
          head_x: x + num_steps,
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        right_segment = {
          head_x: left_segment[:head_x] + 2,
          head_y: y,
          tail_x: left_segment[:head_x] + 2 + num_steps,
          tail_y: y,
        }

        segments += [left_segment, right_segment]
      end
    end

    segments.map do |segment|
      segment[:color] = "black"
      segment[:length] = length

      segment
    end
  end

  def black_vertical
    starting_points = [
      { x: 22, y: 8 },
      { x: 1, y: 8 },
    ]
    length = 6
    num_steps = length - 1
    num_cols = 6
    segments = []

    starting_points.each do |coords|
      start_x, y = coords[:x], coords[:y]

      num_cols.times do |col_idx|
        x = start_x + col_idx

        upper_segment = {
          head_x: x,
          head_y: y + num_steps,
          tail_x: x,
          tail_y: y,
        }

        lower_segment = {
          head_x: x,
          head_y: upper_segment[:head_y] + 2,
          tail_x: x,
          tail_y: upper_segment[:head_y] + 2 + num_steps,
        }

        segments += [upper_segment, lower_segment]
      end
    end

    segments.map do |segment|
      segment[:color] = "black"
      segment[:length] = length

      segment
    end
  end

  def purple
    starting_points = [
      { x: 8, y: 8 },
      { x: 17, y: 8 },
      { x: 17, y: 17 },
      { x: 8, y: 17 },
    ]
    length = 4
    num_steps = length - 1
    num_rows = 4
    segments = []

    starting_points.each do |coords|
      x, start_y = coords[:x], coords[:y]

      num_rows.times do |row_idx|
        y = start_y + row_idx

        forward_segment = {
          head_x: x,
          head_y: y,
          tail_x: x + num_steps,
          tail_y: y,
        }

        reverse_segment = {
          head_x: x + num_steps,
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        segments += [forward_segment, reverse_segment]
      end
    end

    segments.map do |segment|
      segment[:color] = "purple"
      segment[:length] = length

      segment
    end
  end

  def yellow_horizontal
    starting_points = [
      { x: 12, y: 8 },
      { x: 12, y: 17 },
    ]
    length = 5
    num_steps = length - 1
    num_rows = 4
    segments = []

    starting_points.each do |coords|
      x, start_y = coords[:x], coords[:y]

      num_rows.times do |row_idx|
        y = start_y + row_idx

        forward_segment = {
          head_x: x,
          head_y: y,
          tail_x: x + num_steps,
          tail_y: y,
        }

        reverse_segment = {
          head_x: x + num_steps,
          head_y: y,
          tail_x: x,
          tail_y: y,
        }

        segments += [forward_segment, reverse_segment]
      end
    end

    segments.map do |segment|
      segment[:color] = "yellow"
      segment[:length] = length

      segment
    end
  end

  def yellow_vertical
    starting_points = [
      { x: 17, y: 12 },
      { x: 8, y: 12 },
    ]
    length = 5
    num_steps = length - 1
    num_cols = 4
    segments = []

    starting_points.each do |coords|
      start_x, y = coords[:x], coords[:y]

      num_cols.times do |col_idx|
        x = start_x + col_idx

        down_segment = {
          head_x: x,
          head_y: y,
          tail_x: x,
          tail_y: y + num_steps,
        }

        up_segment = {
          head_x: x,
          head_y: y + num_steps,
          tail_x: x,
          tail_y: y,
        }

        segments += [down_segment, up_segment]
      end
    end

    segments.map do |segment|
      segment[:color] = "yellow"
      segment[:length] = length

      segment
    end
  end

  def yellow_center
    top_left = { x: 12, y: 12 }
    top_right = { x: 16, y: 12 }
    bottom_right = { x: 16, y: 16 }
    bottom_left = { x: 12, y: 16 }

    length = 5

    segment1 = {
      head_x: top_left[:x],
      head_y: top_left[:y],
      tail_x: top_right[:x],
      tail_y: top_right[:y],
    }

    segment2 = {
      head_x: top_right[:x],
      head_y: top_right[:y],
      tail_x: bottom_right[:x],
      tail_y: bottom_right[:y],
    }

    segment3 = {
      head_x: bottom_right[:x],
      head_y: bottom_right[:y],
      tail_x: bottom_left[:x],
      tail_y: bottom_left[:y],
    }

    segment4 = {
      head_x: bottom_left[:x],
      head_y: bottom_left[:y],
      tail_x: top_left[:x],
      tail_y: top_left[:y],
    }

    segments = [segment1, segment2, segment3, segment4]

    segments.map do |segment|
      segment[:color] = "yellow"
      segment[:length] = length

      segment
    end
  end

  def purple_center
    length = 2

    segment1 = {
      head_x: 14,
      head_y: 13,
      tail_x: 13,
      tail_y: 13,
    }

    segment2 = {
      head_x: 13,
      head_y: 14,
      tail_x: 13,
      tail_y: 15,
    }

    segment3 = {
      head_x: 15,
      head_y: 13,
      tail_x: 15,
      tail_y: 14,
    }

    segment4 = {
      head_x: 15,
      head_y: 15,
      tail_x: 14,
      tail_y: 15,
    }

    segments = [segment1, segment2, segment3, segment4]

    segments.map do |segment|
      segment[:color] = "purple"
      segment[:length] = length

      segment
    end
  end
end
