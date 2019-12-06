class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def >(other_move)
    rock? && other_move.scissors? ||
      paper? && other_move.rock? ||
      scissors? && other_move.paper?
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name
  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "please choose rock, paper or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer, :scoreboard

  def initialize

    @human = Human.new
    @computer = Computer.new
    @scoreboard = {human => 0, computer => 0}

  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_scoreboard
    puts "The score is: "
    puts "#{human.name}: #{scoreboard[human]} "
    puts "#{computer.name}: #{scoreboard[computer]}"
    puts "The first to 2 wins!"
  end
  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  def display_round_winner
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"

    if human.move > computer.move
      scoreboard[human] += 1
      puts "#{human.name} won the round!"
    elsif computer.move > human.move
      scoreboard[computer] += 1
      puts "#{computer.name} won the round!"
    else
      puts "It's a tie!"
    end

    def winner?
      scoreboard.values.include?(2)
    end

    def display_winner

      return puts "#{human.name} won the game!" if scoreboard[human] == 2
      return puts "#{computer.name} won the game!" if scoreboard[computer] == 2
    end
    # case human.move
    # when 'rock'
    #   puts "It's a tie!" if computer.move == 'rock'
    #   puts "#{human.name} won!" if computer.move == 'scissors'
    #   puts "#{computer.name} won!" if computer.move == 'paper'
    # when 'paper'
    #   puts "It's a tie!" if computer.move == 'paper'
    #   puts "#{human.name} won!" if computer.move == 'rock'
    #   puts "#{computer.name} won!" if computer.move == 'scissors'
    # when 'scissors'
    #   puts "It's a tie!" if computer.move == 'scissors'
    #   puts "#{human.name} won!" if computer.move == 'paper'
    #   puts "#{computer.name} won!" if computer.move == 'rock'
    # end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n. "
    end

    return true if answer == 'y'
    false
  end


  def game
    loop do 
      display_scoreboard
      human.choose
      computer.choose
      puts ""
      display_round_winner
      break if winner?
    end
    display_winner
  end

  def play
    display_welcome_message

    loop do

      game

      break unless play_again?
    end
    display_goodbye_message
  end
end

game = RPSGame.new
game.play
