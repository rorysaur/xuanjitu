class Character < ActiveRecord::Base
  belongs_to :position
  enum form: { classical: "classical", simplified: "simplified" }

  delegate :x_coordinate, :y_coordinate, to: :position
end
