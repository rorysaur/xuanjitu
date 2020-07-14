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

      green_readings = enabled_readings.color(:green)
      black_readings = enabled_readings.color(:black)
      yellow_readings = enabled_readings.color(:yellow)
      purple_readings = enabled_readings.color(:purple)

      outer_readings = green_readings.zip(black_readings).flatten.compact

      inner_readings =
        purple_readings.
        zip(yellow_readings).
        push(yellow_readings.last).
        flatten.
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
