require_relative "./reading_generator"

class ReadingGeneratorGreen < ReadingGenerator
  def initialize(attrs)
    super(attrs)
    @orientation = :horizontal
  end

  private

  def color
    "green"
  end

  def get_head_coordinates(row_idx)
    case style
    when :long
      get_head_coordinates_long(row_idx)
    when :short
      get_head_coordinates_short(row_idx)
    when :alternating
      get_head_coordinates_alternating(row_idx)
    end
  end

  def get_head_coordinates_long(row_idx)
    left_to_right = possible_head_coordinates[:left_to_right]
    right_to_left = possible_head_coordinates[:right_to_left]

    if direction_mode == :conventional # aka "evens start on left"
      row_idx.even? ? left_to_right : right_to_left
    elsif direction_mode == :reversed # aka "evens start on right"
      row_idx.even? ? right_to_left : left_to_right
    end
  end

  def get_head_coordinates_short(row_idx)
    min_x =
      if side == :left
        left_min
      elsif side == :right
        right_min
      end

    max_x = min_x + num_steps

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

    [head_x]
  end

  def get_head_coordinates_alternating(row_idx)
    head_x =
      if from_center
        if direction_mode == :conventional # aka "evens on left"
          row_idx.even? ? left_max : right_min
        elsif direction_mode == :reversed # aka "evens on right"
          row_idx.even? ? right_min : left_max
        end
      else
        if direction_mode == :conventional # aka "read left to right"
          if ascending_order
            row_idx.even? ? left_min : right_min
          else
            row_idx.even? ? right_min : left_min
          end
        elsif direction_mode == :reversed # aka "read right to left"
          if ascending_order
            row_idx.even? ? right_max : left_max
          else
            row_idx.even? ? left_max : right_max
          end
        end
      end

    [head_x]
  end

  def get_line_numbers(row_idx)
    line_numbers =
      case style
      when :long
        diff = (row_idx * 2) + 1
        line_number1 = ascending_order ? diff : (num_lines - diff)
        line_number2 = line_number1 + 1
        [line_number1, line_number2]
      when :short, :alternating
        line_number = ascending_order ? (row_idx + 1) : (num_lines - row_idx)
        [line_number]
      end

    line_numbers
  end

  def line_length
    @line_length ||= style_mappings[style][:line_length]
  end

  def lines_per_row
    @lines_per_row ||= style_mappings[style][:lines_per_row]
  end

  def num_lines
    @num_lines ||= style_mappings[style][:num_lines]
  end

  def num_rows
    6
  end

  def possible_head_coordinates
    if from_center
      {
        left_to_right: [left_max, right_min],
        right_to_left: [right_min, left_max],
      }
    else
      {
        left_to_right: [x, right_min],
        right_to_left: [right_max, left_max],
      }
    end
  end

  def style_mappings
    {
      long: {
        line_length: 3,
        num_lines: 12,
        lines_per_row: 2,
      },
      short: {
        line_length: 3,
        num_lines: 6,
        lines_per_row: 1,
      },
      alternating: {
        line_length: 3,
        num_lines: 6,
        lines_per_row: 1,
      },
    }
  end
end
