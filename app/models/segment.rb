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
