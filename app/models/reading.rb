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

  validates :number, uniqueness: { scope: :color }

  def lines
    segments.order(:line_number)
  end
end