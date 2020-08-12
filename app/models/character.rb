class Character < ActiveRecord::Base
  belongs_to :position
  has_many :pinyin_forms
  has_many :character_segment_assignments
  has_many :segments, through: :character_segment_assignments
  enum form: { classical: "classical", simplified: "simplified" }

  delegate :x_coordinate, :y_coordinate, :color, to: :position

  def pinyin
    # a semi-arbitrary hunch that the last form listed tends to be the best
    pinyin_forms.max { |a, b| a.id <=> b.id }.text_diacritic
  end
end
