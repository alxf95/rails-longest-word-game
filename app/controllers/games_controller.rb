class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def initialize
    @running_score = 0
  end

  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    user_word = params[:word].split('')
    grid = eval(params[:letters])
    user_word.each do |letter|
      up = letter.upcase
      if grid.include? up
        grid.delete(up)
      else
        @result = "Sorry, #{user_word.join} isn't present in the grid."
      end
      # raise
    end
    if find_word(user_word) && @result != "Sorry, #{user_word.join} isn't present in the grid."
      @result = "Well done! #{user_word.join.capitalize} is a valid word!"
      @running_score += user_word.length
    elsif @result != "Sorry, #{user_word.join} isn't present in the grid."
      @result = "Sorry, #{user_word.join} is not a valid word."
    end
  end

  def find_word(wrd)
    url = Nokogiri::HTML(open("https://wagon-dictionary.herokuapp.com/#{wrd.join}.json"))
    parsed = JSON.parse(url)
    parsed['found']
  end
end
