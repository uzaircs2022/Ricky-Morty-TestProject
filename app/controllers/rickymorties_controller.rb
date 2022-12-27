class RickymortiesController < ApplicationController
  require 'rickmorty'
  # require 'rest-client'

  def index
    #FOR POSTMAN
    # render json: RickymortyService.perform

    #FOR CONSOLE
    puts RickymortyService.perform
  end
end
