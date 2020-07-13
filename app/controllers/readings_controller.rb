class ReadingsController < ApplicationController
  def index
    @readings = Reading.includes(:segments).enabled
  end
end
