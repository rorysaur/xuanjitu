class ReadingsController < ApplicationController
  def index
    @readings = Reading.includes(:segments).all
  end
end
