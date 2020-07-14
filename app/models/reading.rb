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

      outer_readings + inner_readings
    end

    def color(color)
      where(color: color)
    end
  end

  def lines
    segments.order(:line_number)
  end
end
