require_relative "./reading_generator_green"
require_relative "./reading_generator_black"
require_relative "./reading_generator_yellow"
require_relative "./reading_generator_purple"

class ReadingGenerator
  def initialize(attrs)
    @reading_number = attrs[:reading_number]
    @x = attrs[:x]
    @y = attrs[:y]
    @block_number = attrs[:block_number]

    # [green:all, black:all]
    @ascending_order = attrs[:ascending_order]

    @direction_mode = attrs[:direction_mode]

    # [green:long, green:alternating, black:short]
    @from_center = attrs[:from_center] || false

    # [green:all]
    @style = attrs[:style] # short, long, alternating, etc;

    # [black:all]
    @orientation = attrs[:orientation]

    # [green:short, black:short]
    @side = attrs[:side]

    # [green:short, black:short, purple]
    @snake = attrs[:snake] || false

    # [black:long]
    @by_couplet = attrs[:by_couplet]

    # [yellow, purple]
    @assigned_line_numbers = attrs[:line_numbers]
  end

  def generate
    results = []

    row_col_indices.each do |row_col_idx|
      line_numbers = get_line_numbers(row_col_idx)
      head_coordinates = get_head_coordinates(row_col_idx)

      lines_per_row.times do |i|
        csv_row = {
          color: color,
          block_number: block_number,
          reading_number: reading_number,
          head_y: horizontal? ? (y + row_col_idx) : head_coordinates[i],
          head_x: horizontal? ? head_coordinates[i] : (x + row_col_idx),
          line_number: line_numbers[i],
          enabled: 1,
        }

        results << csv_row
      end
    end

    results
  end

  private

  attr_accessor(
    :reading_number,
    :x,
    :y,
    :block_number,
    :ascending_order,
    :direction_mode,
    :from_center,
    :style,
    :orientation,
    :side,
    :snake,
    :by_couplet,
    :assigned_line_numbers,
  )

  def horizontal?
    orientation == :horizontal
  end

  def vertical?
    orientation == :vertical
  end

  def left_min
    raise "can only be called for horizontal blocks" unless horizontal?

    x
  end

  def left_max
    raise "can only be called for horizontal blocks" unless horizontal?

    left_min + num_steps
  end

  def right_min
    raise "can only be called for horizontal blocks" unless horizontal?

    x + line_length
  end

  def right_max
    raise "can only be called for horizontal blocks" unless horizontal?

    right_min + num_steps
  end

  def upper_min
    raise "can only be called for vertical blocks" unless vertical?

    y
  end

  def upper_max
    raise "can only be called for vertical blocks" unless vertical?

    upper_min + num_steps
  end

  def lower_min
    raise "can only be called for vertical blocks" unless vertical?

    y + line_length
  end

  def lower_max
    raise "can only be called for vertical blocks" unless vertical?

    lower_min + num_steps
  end

  def num_steps
    @num_steps ||= line_length - 1
  end

  def row_col_indices
    num_row_cols = horizontal? ? num_rows : num_cols
    indices = (0...num_row_cols).to_a
    ascending_order ? indices : indices.reverse
  end
end
