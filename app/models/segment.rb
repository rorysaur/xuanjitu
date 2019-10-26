class Segment < ActiveRecord::Base
  belongs_to :head_position, class_name: "Position"
  belongs_to :tail_position, class_name: "Position"

  enum color: {
    black: "black",
    blue: "blue",
    green: "green",
    purple: "purple",
    red: "red",
    yellow: "yellow",
  }

  class << self
    def as_grid_by_tail
      segments = Segment.includes(:head_position, :tail_position).all

      grid = Array.new(29){Array.new(29)}

      (0..28).each do |y|
        (0..28).each do |x|
          grid[y][x] = segments.select do |segment|
            segment.tail_x == x && segment.tail_y == y
          end
        end
      end

      grid
    end
  end

  def head_x
    head_position.x_coordinate
  end

  def head_y
    head_position.y_coordinate
  end

  def tail_x
    tail_position.x_coordinate
  end

  def tail_y
    tail_position.y_coordinate
  end
end
