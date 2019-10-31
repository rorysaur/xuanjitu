class SegmentsController < ApplicationController
  def index
    @segments = Segment.includes(:head_position, :tail_position).all
  end
end
