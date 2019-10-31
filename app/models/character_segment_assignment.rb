class CharacterSegmentAssignment < ActiveRecord::Base
  belongs_to :character
  belongs_to :segment
end
