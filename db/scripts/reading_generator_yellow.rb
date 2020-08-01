require_relative "./reading_generator"

class ReadingGeneratorYellow < ReadingGenerator
  def initialize(attrs)
    super(attrs)
    @orientation = (block_number % 4 == 0) ? :vertical : :horizontal
  end

  private

  def assigned_line_numbers
    if horizontal?
      @assigned_line_numbers
    elsif vertical?
      @assigned_line_numbers.reverse
    end
  end

  def color
    "yellow"
  end

  def direction_mode
    # a terrible little change that renders the `direction_mode` variable
    # meaningless, but makes the same code work for both horizontal and
    # vertical blocks with snaking lines
    if snake && vertical?
      if @direction_mode == :conventional
        :reversed
      elsif @direction_mode == :reversed
        :conventional
      end
    else
      @direction_mode
    end
  end

  def get_head_coordinates(row_col_idx)
    head_coordinate =
      if snake
        if direction_mode == :conventional # aka "evens start on left / from top"
          row_col_idx.even? ? head_min : head_max
        elsif direction_mode == :reversed # aka "evens start on right / from bottom"
          row_col_idx.even? ? head_max : head_min
        end
      else
        if direction_mode == :conventional # left to right / top to bottom
          head_min
        elsif direction_mode == :reversed # right to left / bottom to top
          head_max
        end
      end

    [head_coordinate]
  end

  def get_line_numbers(row_col_idx)
    [assigned_line_numbers[row_col_idx]]
  end

  def head_min
    if horizontal?
      left_min
    elsif vertical?
      upper_min
    end
  end

  def head_max
    if horizontal?
      left_max
    elsif vertical?
      upper_max
    end
  end

  def line_length
    5
  end

  def lines_per_row
    1
  end

  def num_lines
    4
  end

  def num_rows
    4
  end

  def num_cols
    4
  end

  def row_col_indices
    num_row_cols = horizontal? ? num_rows : num_cols
    (0...num_row_cols).to_a
  end
end
