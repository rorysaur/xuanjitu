class CharactersController < ApplicationController
  def index
    @characters = Character.includes(:pinyin_forms, :position, :segments).all
  end
end
