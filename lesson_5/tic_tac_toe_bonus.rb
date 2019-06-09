class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]] # diagonals

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts ""
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :name
  attr_reader :marker

  def initialize(marker)
    @marker = marker
    @name = "R2D2"
  end
end

class ScoreBoard
  attr_accessor :human, :computer
  def initialize
    @human = 0
    @computer = 0
  end

  def display_game
    "Your Score: #{human}, Computer Score: #{computer}"
  end

  def clear
    @human = 0
    @computer = 0
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  SCORE_NEEDED_TO_WIN = 2 # easier for testing purposes

  attr_reader :board, :human, :computer
  attr_accessor :scoreboard

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @scoreboard = ScoreBoard.new
  end

  def play
    clear
    display_welcome_message
    set_name_for_player
    play_game
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts ""
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def set_name_for_player
    loop do 
      puts "What is your name?"
      human.name = gets.chomp
      break unless human.name.empty?
      puts "Not a valid name, try again"
    end
  end

  def round_moves
    loop do
      display_game_total
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def play_round
    loop do
      display_board
      round_moves
      add_point
      break if game_winner?
      display_result
      display_game_total
      puts "Round finished. Press any key to continue"
      gets
      reset
    end
  end

  def play_game
    loop do
      set_marker_for_player
      set_game_order
      clear
      play_round
      display_game_winner
      break unless play_again?
      reset
      scoreboard.clear
      display_play_again_message
    end
  end

  def set_marker_for_player
    choice = ''
    loop do
      puts "Select your marker: type 'x' to be X, type 'o' to be O"
      choice = gets.chomp.upcase

      break if choice == HUMAN_MARKER || choice == COMPUTER_MARKER
      puts "Invalid answer, try again"
    end

    COMPUTER_MARKER.replace("X") if choice == COMPUTER_MARKER
    HUMAN_MARKER.replace("O") if choice == COMPUTER_MARKER
  end

  def set_game_order
    answer = nil
    loop do
      puts "Would you like to play first? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    choice = if answer == "y"
               HUMAN_MARKER
             else
               COMPUTER_MARKER
             end

    @@first_to_move = choice
    @current_marker = @@first_to_move
  end

  def display_board
    puts "#{human.name}, your marker is #{human.marker}."
    puts "#{computer.name}'s marker is #{computer.marker}."
    puts "First player to win #{SCORE_NEEDED_TO_WIN} rounds wins!"
    puts ""
    board.draw
    puts ""
  end

  def display_game_total
    puts "Your Score: #{scoreboard.human}"
    puts "Computer Score: #{scoreboard.computer}"
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice"
    end

    board[square] = human.marker
  end

  def immediate_win?(player)
    !immediate_win(player).nil?
  end

  def available_winning_lines(player)
    opposing_marker = HUMAN_MARKER
    opposing_marker = COMPUTER_MARKER if player == human
    Board::WINNING_LINES.select do |line|
      squares = board.squares.values_at(*line)
      opposing_squares = squares.select { |sq| sq.marker == opposing_marker }

      num_of_marked = squares.count { |sq| sq.marker == player.marker }

      num_of_marked == 2 && opposing_squares.empty?
    end
  end

  def winning_square(winners)
    winners.first.find { |num| board.unmarked_keys.include?(num) }
  end

  def immediate_win(player)
    winners = available_winning_lines(player)
    winning_square(winners) unless winners.empty?
  end

  def unmarked_middle_sq?
    board.squares[5].marker == Square::INITIAL_MARKER
  end

  def win_the_game(player)
    board[immediate_win(player)] = player.marker
  end

  def steal_win_from_human
    board[immediate_win(human)] = computer.marker
  end

  def take_middle_square
    board[5] = computer.marker
  end

  def computer_moves
    if immediate_win?(computer)
      win_the_game(computer)

    elsif immediate_win?(human)
      steal_win_from_human

    elsif unmarked_middle_sq?
      take_middle_square
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def game_winner?
    [scoreboard.human, scoreboard.computer].include?(SCORE_NEEDED_TO_WIN)
  end

  def add_point
    case board.winning_marker
    when human.marker
      scoreboard.human += 1
    when computer.marker
      scoreboard.computer += 1
    end
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won the round!"
    when computer.marker
      puts "Computer won the round!"
    else
      puts "It's a tie!"
    end
  end

  def display_game_winner
    clear_screen_and_display_board
    if scoreboard.human == SCORE_NEEDED_TO_WIN
      puts "YOU WON THE GAME!"
    else
      puts "COMPUTER WON THE GAME!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = @@first_to_move
    clear
  end
end

game = TTTGame.new
game.play
