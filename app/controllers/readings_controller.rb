class ReadingsController < ApplicationController
  def index
    @readings = Reading.in_demo_order
  end
end
