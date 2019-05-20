class Board
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
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class Computer < Player

  attr_accessor :board

  def initialize(marker, board)
    super(marker)
    @board = board
  end

  def move



    # if there are two squares checked, mark the third

    # if an immediate threat, choose a square

    # go through winninglines, if the line has two human markers, pick the third

    board[board.unmarked_keys.sample] = self.marker
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
  FIRST_TO_MOVE = HUMAN_MARKER
  SCORE_NEEDED_TO_WIN = 2

  attr_reader :board, :human, :computer
  attr_accessor :scoreboard

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER, board)
    @current_marker = FIRST_TO_MOVE
    @scoreboard = ScoreBoard.new
  end

  def play
    clear
    display_welcome_message

    loop do 
        loop do
          display_board
          loop do
          display_game_total

            current_player_moves
            break if board.someone_won? || board.full?
            clear_screen_and_display_board
          end

          display_result

          break if game_winner?
          
          display_game_total

          puts "Round finished. Press any key to continue"
          any_key = gets.chomp
          reset
        end
        display_game_winner
        break unless play_again?
        reset
        scoreboard.clear
        display_play_again_message
      end

    display_goodbye_message
  end

  private


  def display_welcome_message
    puts ""
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system 'clear'
  end

  def display_game_total
    puts "Your Score: #{scoreboard.human}, Computer Score: #{scoreboard.computer}"
  end


  def game_winner?
    scoreboard.human == SCORE_NEEDED_TO_WIN || scoreboard.computer == SCORE_NEEDED_TO_WIN
  end

  def display_game_winner
    puts "SOMEONE WON!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer.move
      @current_marker = HUMAN_MARKER
    end
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

  # def computer_moves



  #   # if there are two squares checked, mark the third

  #   # if an immediate threat, choose a square

  #   # go through winninglines, if the line has two human markers, pick the third

  #   board[board.unmarked_keys.sample] = computer.marker
  # end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker 
      scoreboard.human += 1
      puts "You won!"
    when computer.marker
      scoreboard.computer += 1
     puts "Computer won!"
    else 
      puts "It's a tie!"
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

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
