class ScoreBoard
  attr_accessor :human, :computer
  
  def initialize

    @human = 0
    @computer = 0

  end
  def display_game
    puts "Your Score: #{human}, Computer Score: #{computer}"
  end


end