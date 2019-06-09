
class GuessingGame

  attr_reader :answer
  attr_accessor :guesses, :guess

  def play
    @guesses = 7
    @answer = (1..100).to_a.sample
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

  def get_guess
    puts "Enter a number between 1 and 100:"
    loop do
      self.guess = gets.chomp.to_i
    break if valid_guess?(guess)
      puts "Invalid Guess. Enter a number between 1 and 100:"
    end
  end

  def valid_guess?(guess)
    (1..100).include?(guess)
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

game = GuessingGame.new
game.play
game.play