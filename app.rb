require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

	enable :sessions
	register Sinatra::Flash

	before do
		@game = session[:game] || HangpersonGame.new('')
	end

	after do
		session[:game] = @game
	end

	# These two routes are good examples of Sinatra syntax
	# to help you with the rest of the assignment
	get '/' do
		redirect '/new'
	end

	get '/new' do
		erb :new
	end

	post '/create' do
		# NOTE: don't change next line - it's needed by autograder!
		word = params[:word] || HangpersonGame.get_random_word
		# NOTE: don't change previous line - it's needed by autograder!

		@game = HangpersonGame.new(word)
		redirect '/show'
	end

	# Use existing methods in HangpersonGame to process a guess.
	# If a guess is repeated, set flash[:message] to "You have already used that letter."
	# If a guess is invalid, set flash[:message] to "Invalid guess."
	post '/guess' do
		letter = params[:guess].to_s[0]
		### YOUR CODE HERE ###
		begin
			state = @game.guess(letter)
			if state == false
				flash[:message] = "You have already used that letter."
			end
		rescue
			flash[:message] = "Invalid guess."
		end
		redirect '/show'
	end

	# Everytime a guess is made, we should eventually end up at this route.
	# Use existing methods in HangpersonGame to check if player has
	# won, lost, or neither, and take the appropriate action.
	# Notice that the show.erb template expects to use the instance variables
	# wrong_guesses and word_with_guesses from @game.
	get '/show' do
		### YOUR CODE HERE ###
		state = @game.check_win_or_lose
		if state == :win
			redirect '/win'
		elsif state == :lose
			redirect '/lose'
		else
			erb :show # You may change/remove this line
		end
	end

	get '/win' do
		### YOUR CODE HERE ###
		state = @game.check_win_or_lose
		if state == :win
			erb :win # You may change/remove this line
		elsif state == :lose
			redirect '/lose'
		else
			redirect '/show' # You may change/remove this line
		end
	end

	get '/lose' do
		### YOUR CODE HERE ###
		state = @game.check_win_or_lose
		if state == :win
			redirect '/win' # You may change/remove this line
		elsif state == :lose
			erb :lose # You may change/remove this line
		else
			redirect '/show' # You may change/remove this line
		end
	end

end
