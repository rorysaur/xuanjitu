class CharactersController < ApplicationController
  def index
    @characters = Character.includes(:position).all
  end
end
