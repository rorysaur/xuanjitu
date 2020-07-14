class Reading < ActiveRecord::Base
  has_many :reading_segment_assignments
  has_many :segments, through: :reading_segment_assignments

  enum color: {
    black: "black",
    blue: "blue",
    green: "green",
    purple: "purple",
    red: "red",
    yellow: "yellow",
  }

  enum interpretation: [:metail, :li_wei]

  scope :enabled, -> { where(enabled: true) }

  validates :number, uniqueness: { scope: [:color, :block_number] }

  class << self
    def in_demo_order
      enabled_readings = includes(:segments).enabled

      green_readings = enabled_readings.color(:green).to_a
      black_readings = enabled_readings.color(:black).to_a
      yellow_readings = enabled_readings.color(:yellow).to_a
      purple_readings = enabled_readings.color(:purple).to_a

      outer_readings = green_readings.zip(black_readings).flatten.compact

      final_readings = [yellow_readings.pop, purple_readings.pop]

      inner_readings =
        purple_readings.
        zip(yellow_readings).
        flatten.
        concat(final_readings).
        compact

      readings_without_red = outer_readings + inner_readings

      red_readings = readings_without_red.map do |reading|
        get_adjacent_red_reading(reading)
      end

      readings_without_red.zip(red_readings).flatten.compact
    end

    def color(color)
      where(color: color)
    end

    def get_adjacent_red_reading(original_reading)
      red_segments = []

      # set some bounds in which to search for a red segment
      sample_segment = original_reading.segments.first
      left_bound = [sample_segment.head_x - red_reading_margin, 0].max
      right_bound = [sample_segment.head_x + red_reading_margin, 28].min
      upper_bound = [sample_segment.head_y - red_reading_margin, 0].max
      lower_bound = [sample_segment.head_y + red_reading_margin, 28].min

      # choose a random red position within the bounds
      red_position = Position.where(
        x_coordinate: left_bound..right_bound,
        y_coordinate: upper_bound..lower_bound,
        color: :red,
      ).sample

      red_character = Character.find_by!(position: red_position)

      first_red_segment = red_character.segments.sample
      red_segments << first_red_segment

      3.times do |_|
        red_segments << red_segments.last.following_segments.sample
      end

      red_reading = Reading.new(color: :red)
      red_reading.segments << red_segments

      red_reading
    end

    def red_reading_margin
      6
    end
  end

  def segments_by_line_number
    segments.order(:line_number)
  end
end
