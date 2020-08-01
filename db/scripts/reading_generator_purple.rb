require_relative "./reading_generator"

class ReadingGeneratorPurple < ReadingGenerator
  def initialize(attrs)
    super(attrs)
    @orientation = :horizontal
    raise "missing direction_mode" if @snake && @direction_mode.nil?
  end

  private

  def color
    "purple"
  end

  def get_head_coordinates(row_idx)
    head_coordinate =
      if snake
        if direction_mode == :conventional
          row_idx.even? ? left_min : left_max
        elsif direction_mode == :reversed
          row_idx.even? ? left_max : left_min
        end
      else
        left_min
      end

    [head_coordinate]
  end

  def get_line_numbers(row_col_idx)
    [assigned_line_numbers[row_col_idx]]
  end

  def row_col_indices
    (0...num_rows).to_a
  end

  def line_length
    4
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
end
