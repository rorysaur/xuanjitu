class Segment < ActiveRecord::Base
  belongs_to :head_position, class_name: "Position"
  belongs_to :tail_position, class_name: "Position"
  has_many :character_segment_assignments
  has_many :characters, through: :character_segment_assignments
  has_many :reading_segment_assignments
  has_many :readings, through: :reading_segment_assignments

  enum color: {
    black: "black",
    blue: "blue",
    green: "green",
    purple: "purple",
    red: "red",
    yellow: "yellow",
  }

  validates :head_position, uniqueness: {  scope: [:color, :length] }

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

  def following_segments
    # segments of the same color whose head position is adjacent to self's tail position
    candidate_segments = Segment.where(
      color: color,
      length: length,
    )

    adjacent_positions = tail_position.adjacent_positions

    # exclude segments that overlap with self
    candidate_segments.select do |candidate_segment|
      candidate_segment.head_position.in?(adjacent_positions) &&
        !overlaps_with?(candidate_segment)
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

  private

  def overlaps_with?(other_segment)
    other_segment.head_position.between?(head_position, tail_position) ||
      other_segment.tail_position.between?(head_position, tail_position)
  end
end
