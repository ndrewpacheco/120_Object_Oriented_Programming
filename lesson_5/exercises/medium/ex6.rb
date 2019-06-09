# Create an object-oriented number guessing class for numbers in the range 1 to 100, 
# with a limit of 7 guesses per game. The game should play like this:

class GuessingGame

  attr_reader :answer, :low, :high
  attr_accessor :guesses, :guess

  def initialize(low, high)
    @low = low
    @high = high
  end

  def play
    @guesses = 7
    @answer = (low..high).to_a.sample
    loop do 
      guesses_remaining
      get_guess

      result
      break if player_lost? || player_won?
    end
    losing_message if player_lost?
    winning_message if player_won? 
  end

  private


  def guesses_remaining
    puts ""
    puts "You have #{guesses} guesses remaining"
  end

  def enter_number
    "Enter a number between #{low} and #{high}:"
  end
  def get_guess
    puts enter_number
    loop do
      self.guess = gets.chomp.to_i
    break if valid_guess?(guess)
      puts "Invalid Guess. #{enter_number}"
    end
  end

  def valid_guess?(guess)
    (low..high).include?(guess)
  end

  def result
    guess_too_low if too_low?
    guess_too_high if too_high?
  end

  def player_won?
    guess == answer
  end

  def player_lost? 
    guesses == 0
  end

  def winning_message
    puts "That's the number!"
    puts ""
    puts "You won!"
  end

  def losing_message
    puts "You have no more guesses. You lost!"
  end

  def too_low?
    guess < answer
  end

  def too_high?
    guess > answer
  end

  def guess_too_low
    minus_guess
    puts "Your guess is too low."
  end

  def guess_too_high
    minus_guess
    puts "Your guess is too high."
  end

  def minus_guess
    self.guesses -= 1
  end
end

game = GuessingGame.new(22, 24)
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!


# Note that a game object should start a new game with a new number to guess with each call to #play.

