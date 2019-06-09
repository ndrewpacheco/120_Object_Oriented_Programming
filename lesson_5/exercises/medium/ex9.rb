require 'pry'
# Deck of Cards
# Using the Card class from the previous exercise,
# create a Deck class that contains all of the standard 52 playing cards. 
# Use the following code to start your work:
class Card
  include Comparable
  attr_reader :rank, :suit
  # constant, an array that will be ordered in rank
  RANKING_SYSTEM = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    RANKING_SYSTEM.index(rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_reader :cards
  def initialize
    reset
  end

  def reset
    @cards = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end
  #cards = an array of all the cards
  # if cards is empty, reset
  def draw
    reset if cards.empty?
    cards.pop
  end

end


# The Deck class should provide a #draw method to draw one card at random.
# If the deck runs out of cards, the deck should reset itself by generating a new set of 52 cards.

#Examples:

deck = Deck.new
drawn = []

52.times do
 drawn << deck.draw 
 #binding.pry
end
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.
#Note that the last line should almost always be true; if you shuffle the deck 1000 times a second, you will be very, very, very old before you see two consecutive shuffles produce the same results. If you get a false result, you almost certainly have something wrong.

