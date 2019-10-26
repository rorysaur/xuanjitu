class SegmentsController < ApplicationController
  def index
    @segments = Segment.as_grid_by_tail
  end
end
