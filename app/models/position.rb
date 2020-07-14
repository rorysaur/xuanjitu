class Position < ActiveRecord::Base
  enum color: {
    black: "black",
    blue: "blue",
    green: "green",
    purple: "purple",
    red: "red",
    yellow: "yellow",
  }

  class << self
    def sort(pos_a, pos_b)
      if pos_a.x_coordinate == pos_b.x_coordinate
        if pos_a.y_coordinate <= pos_b.y_coordinate
          [pos_a, pos_b]
        else
          [pos_b, pos_a]
        end
      elsif pos_a.y_coordinate == pos_b.y_coordinate
        if pos_a.x_coordinate <= pos_b.x_coordinate
          [pos_a, pos_b]
        else
          [pos_b, pos_a]
        end
      else
        raise "diagonal sort not yet implemented"
      end
    end
  end

  def adjacent_positions
    Position.where(
      x_coordinate: (x_coordinate - 1)..(x_coordinate + 1),
      y_coordinate: (y_coordinate - 1)..(y_coordinate + 1),
    )
  end

  def between?(pos_a, pos_b)
    start_pos, end_pos = Position.sort(pos_a, pos_b)

    x_coordinate.between?(start_pos.x_coordinate, end_pos.x_coordinate) &&
      y_coordinate.between?(start_pos.y_coordinate, end_pos.y_coordinate)
  end
end
