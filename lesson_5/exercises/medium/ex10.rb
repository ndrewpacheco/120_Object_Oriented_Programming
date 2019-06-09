require 'pry'
# Include Card and Deck classes from the last two exercises.
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


class PokerHand
  attr_reader :hand
  def initialize(deck)
    @hand = []
    5.times { @hand << deck.draw }
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def has_ace?
    hand.any? {|card| card.rank == "Ace" }
  end

  def ranks_of_hand
    hand.sort.map {|card| card.rank }
  end

  def matching_cards?(num)
    Deck::RANKS.each do |rank|

      return true if ranks_of_hand.count(rank) == num
    end
    false
  end

  def royal_flush?
    ranks_of_hand.first == 10 && straight_flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    matching_cards?(4)
  end

  def full_house?
    matching_cards?(3) && matching_cards?(2)
  end

  def flush?
    # all suits are the same
    flush_suit = hand.first.suit
    hand.all?{|card| card.suit == flush_suit }
  end

  def straight?

    idx = Deck::RANKS.index(ranks_of_hand.first)
    deck_arr = Deck::RANKS.slice(idx, 5)
    ranks_of_hand == deck_arr
    
  end

  def three_of_a_kind?
    matching_cards?(3)
  end

  def two_pair?
    two_pair_arr = []
    ranks_of_hand.each do |rank|

      two_pair_arr << rank if ranks_of_hand.count(rank) == 2
      
    end
    two_pair_arr.uniq.size == 2
  end

  def pair?
    matching_cards?(2)
  end
end

# testing:

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts "royal_flush".upcase
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts "straight_flush".upcase
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts "four_of_a_kind".upcase
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts "full_house".upcase
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts "flush".upcase
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts "straight".upcase
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts "straight".upcase
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts "Three of a kind".upcase
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts "two_pair".upcase
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts "pair".upcase
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts "high card".upcase
puts hand.evaluate == 'High card'