require_relative "./reading_generator"

class ReadingGeneratorBlack < ReadingGenerator
  def initialize(attrs)
    super(attrs)

    raise "you need to specify a direction_mode" if @from_center && @direction_mode.nil?
    raise "you need to specify a side" if (@style == :short) && !@from_center && @side.nil?
  end

  private

  def color
    "black"
  end

  def get_head_coordinates(row_idx)
    case style
    when :long
      get_head_coordinates_long
    when :short
      get_head_coordinates_short(row_idx)
    end
  end

  def get_head_coordinates_long
    possible_head_coordinates[direction_mode]
  end

  def get_head_coordinates_short(row_col_idx)
    head_coordinate =
      if from_center
        if direction_mode == :conventional # aka "evens on left"
          row_col_idx.even? ? head_min : head_max
        elsif direction_mode == :reversed # aka "evens on right"
          row_col_idx.even? ? head_max : head_min
        end
      else
        case side
        when :left
          left_max
        when :right
          right_min
        when :upper
          upper_max
        when :lower
          lower_min
        end
      end

    [head_coordinate]
  end

  def head_min
    if horizontal?
      left_max
    elsif vertical?
      upper_max
    end
  end

  def head_max
    if horizontal?
      right_min
    elsif vertical?
      lower_min
    end
  end

  def get_line_numbers(row_col_idx)
    line_numbers =
      case style
      when :long
        if by_couplet
          if ascending_order
            even_row_col = (row_col_idx * 2) + 1
            odd_row_col = row_col_idx * 2
          else
            even_row_col = num_lines - ((row_col_idx * 2) + 2)
            odd_row_col = num_lines - ((row_col_idx * 2) + 1)
          end

          line_number1 = row_col_idx.even? ? even_row_col : odd_row_col
          line_number2 = line_number1 + 2
        else
          diff = (row_col_idx * 2) + 1
          line_number1 = ascending_order ? diff : (num_lines - diff)
          line_number2 = line_number1 + 1
        end

        [line_number1, line_number2]
      when :short
        line_number = ascending_order ? (row_col_idx + 1) : (num_lines - row_col_idx)
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

  def num_cols
    6
  end

  def possible_head_coordinates
    {
      conventional: [head_min, head_max],
      reversed: [head_max, head_min],
    }
  end

  def right_min
    left_min + line_length + 1
  end

  def lower_min
    upper_min + line_length + 1
  end

  def style_mappings
    {
      long: {
        line_length: 6,
        num_lines: 12,
        lines_per_row: 2,
      },
      short: {
        line_length: 6,
        num_lines: 6,
        lines_per_row: 1,
      },
    }
  end
end
