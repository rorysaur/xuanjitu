class Character < ActiveRecord::Base
  belongs_to :position
  enum form: { classical: "classical", simplified: "simplified" }

  delegate :x_coordinate, :y_coordinate, :color, to: :position
end
