class Character < ActiveRecord::Base
  belongs_to :position
  has_many :character_segment_assignments
  has_many :segments, through: :character_segment_assignments
  enum form: { classical: "classical", simplified: "simplified" }

  delegate :x_coordinate, :y_coordinate, :color, to: :position
end
