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
      results = []
      all_readings = Reading.includes(:segments).enabled

      # in each block there are between 1-24 readings.  looping through the
      # blocks, pick the next reading from each block, until there are no more
      # readings.

      loop do
        readings_found_for_reading_number = false

        (1..num_blocks).each do |block_number|
          readings = all_readings.select do |rdg|
            rdg.block_number == block_number && rdg.number == reading_number
          end
          non_red_reading = readings.find { |reading| !reading.red? }
          red_reading = readings.find(&:red?)

          unless readings.empty?
            results += [non_red_reading, red_reading].compact
            readings_found_for_reading_number = true
          end
        end

        break unless readings_found_for_reading_number

        reading_number += 1
      end

      results
    end

    def in_demo_order
      in_block_order
    end

    def color(color)
      where(color: color)
    end

    def create_adjacent_red_reading!(original_reading)
      red_reading = Reading.create!(
        interpretation: 0,
        color: :red,
        block_number: original_reading.block_number,
        number: original_reading.number,
        enabled: true,
      )

      red_segments = []

      # set some bounds in which to search for a red segment
      sample_segment = original_reading.segments.first
      left_bound = [sample_segment.head_x - red_reading_margin, 0].max
      right_bound = [sample_segment.head_x + red_reading_margin, 28].min
      upper_bound = [sample_segment.head_y - red_reading_margin, 0].max
      lower_bound = [sample_segment.head_y + red_reading_margin, 28].min

      # choose a random red position within the bounds
      red_position = Position.includes(:character).where(
        x_coordinate: left_bound..right_bound,
        y_coordinate: upper_bound..lower_bound,
        color: :red,
      ).sample

      first_red_segment = red_position.character.segments.sample
      red_segments << first_red_segment

      3.times do |_|
        red_segments << red_segments.last.following_segments.sample
      end

      red_segments.each_with_index do |segment, idx|
        ReadingSegmentAssignment.create!(
          reading: red_reading,
          segment: segment,
          line_number: idx + 1,
        )
      end

      red_reading
    end

    def find_adjacent_red_reading(original_reading)
      Reading.enabled.includes(:segments).find_by(
        interpretation: 0,
        color: :red,
        block_number: original_reading.block_number,
        number: original_reading.number,
      )
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
