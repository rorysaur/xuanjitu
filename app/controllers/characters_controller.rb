class CharactersController < ApplicationController
  def index
    @characters = Character.includes(:position, :segments).all
  end
end
