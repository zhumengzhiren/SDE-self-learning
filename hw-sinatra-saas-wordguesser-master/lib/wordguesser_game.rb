class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError unless valid_guess?(letter)
    letter = letter.downcase 
    # Check if the letter is in the word

    # Check if the letter has already been guessed
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses += letter unless @guesses.include?(letter)
      true
    else
      @wrong_guesses += letter unless @wrong_guesses.include?(letter)
      true
    end
  end

  def valid_guess?(letter)
    return false if letter.nil? || letter.empty? || letter !~ /[a-zA-Z]/
    true
  end

  def guess_several_letters(game, letters)
    letters.each_char { |letter| game.guess(letter) }
  end

  def word_with_guesses
    displayed_word = ''
    @word.each_char do |char|
      if @guesses.include?(char)
        displayed_word += char
      else
        displayed_word += '-'
      end
    end
    displayed_word
  end

  def check_win_or_lose
    if @word.split('').all? { |char| @guesses.include?(char) }
      :win
    elsif @wrong_guesses.size >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end


