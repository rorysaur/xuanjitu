class Reading < ActiveRecord::Base
  has_many :reading_segment_assignments, -> { order(:line_number) }
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
    def in_block_order
      num_blocks = 18
      reading_number = 1
      # messages = []
      results = []
      all_readings = Reading.includes(:segments).enabled

      # in each block there are between 1-24 readings.
      # pick the next reading from each block, until there are no more
      # readings.

      loop do
        readings_found_for_reading_number = false

        (1..num_blocks).each do |block_number|
          reading = all_readings.select do |rdg|
            rdg.block_number == block_number && rdg.number == reading_number
          end

          if reading.present?
            # messages << "reading found: #{reading.color}, block #{block_number}, reading #{reading_number}"
            results << reading
            readings_found_for_reading_number = true
          end
        end

        if readings_found_for_reading_number
          reading_number += 1
        else
          break
        end
      end

      # puts messages.join("\n")
      results
    end

    def in_demo_order
      readings_without_red = Reading.in_block_order

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

  def enable!
    update!(enabled: true)
  end

  def disable!
    update!(enabled: false)
  end

  def segments_by_line_number
    segments.order(:line_number)
  end
end
