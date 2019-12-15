class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(guess_word)
	if guess_word == '' || guess_word == nil
		raise ArgumentError
	end

	if not guess_word.match /[[:alpha:]]/
		raise ArgumentError
	end

	@guesses.chars.each do |char|
		if char == guess_word.downcase
			return false
		end
	end

	@wrong_guesses.chars.each do |char|
		if char == guess_word.downcase
			return false
		end
	end

	@word.chars.each do |letter|
		if guess_word == letter
			@guesses << guess_word.downcase
			return true
		end
	end
	@wrong_guesses << guess_word
	return true 
  end

  def word_with_guesses
	display = ''
	appended = false
	@word.chars.each do |letter|
		appended = false
		@guesses.chars.each do |charac|
			if charac == letter
				display << letter
				appended = true
			end
		end
		if not appended
			display << '-'
		end
	end
	return display
  end

  def check_win_or_lose
	if @wrong_guesses.chars.count > 6
		return :lose
	else
		word_with_guesses.chars.each do |char|
			if char == '-'
				return :play
			end
		end
	end
	return :win
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
