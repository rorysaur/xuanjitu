class ReadingSegmentAssignment < ActiveRecord::Base
  belongs_to :reading
  belongs_to :segment
end
