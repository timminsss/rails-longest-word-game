require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    # check if valid english word
    @english_word = valid_english_word(@word)
    # check if exists in grid
    @grid_word = valid_word_in_grid(@grid, @word)

    if @english_word && @grid_word
      @message = "Word exists - well done"
      if session[:running_total]
        session[:running_total] += @length
      else
        session[:running_total] = @length
      end
    else
      @message = "No you lose"
    end

  end

  private

  def valid_english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    user = JSON.parse(response)
    @found = user["found"]
    @length = user["length"]
  end

  def valid_word_in_grid(grid, word)
    grid = grid.upcase.split(' ')
    word_chars = word.upcase.chars
    in_grid = true
    word_chars.each do |char|
      if grid.include?(char)
        index = grid.find_index(char)
        grid.delete_at(index)
      else
        in_grid = false
      end
    end
    return in_grid
  end
end
