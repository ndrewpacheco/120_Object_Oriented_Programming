class Participant
  attr_accessor :cards_in_hand, :name

  def initialize
    @cards_in_hand = []
  end

  def hit(deck)
    deck.deal(self)
  end

  def busted?
    total > 21
  end

  def show_cards
    size = cards_in_hand.size
    size.times do |num|
      puts show_card(num)
    end
  end

  def show_card(idx)
    card = cards_in_hand[idx]
    "#{card.num} of #{card.suit.capitalize}"
  end

  def total
    sum = 0
    cards_in_hand.each do |card|
      sum += card.value if card.num != "Ace"
    end

    cards_in_hand.each do |card|
      if card.num == "Ace"
        sum += if sum <= 10
                 card.value[0]
               else
                 card.value[1]
               end
      end
    end
    sum
  end

  def clear_cards
    @cards_in_hand = []
  end
end

class Player < Participant
  def stay?
    answer = nil
    loop do
      puts "Would you like to hit or stay? Press 'h' for hit, 's' to stay"
      answer = gets.chomp.downcase
      puts ""
      break if ['h', 's'].include?(answer)
      puts "That was not a valid answer, try again."
    end
    answer == "s"
  end

  def show_total
    return puts "You busted!" if total > 21
    puts "Your total is: #{total}"
  end

  def show_cards
    puts "#{name}, your cards are:"
    super
  end
end

class Dealer < Participant
  def show_total
    return puts "Dealer busted!" if total > 21
    puts "Dealer's total is: #{total}"
  end

  def show_cards
    puts "The Dealer's cards are:"
    super
  end
end

class Deck
  attr_reader :cards

  SUITS = [:hearts, :clubs, :diamonds, :spades]
  CARD_VALUE = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "Jack" => 10,
    "Queen" => 10,
    "King" => 10,
    "Ace" => [11, 1]
  }

  def initialize
    @cards = []
    SUITS.each do |suit|
      CARD_VALUE.each do |num, value|
        cards << Card.new(suit, num, value)
      end
    end
  end

  def deal(participant)
    card = cards.sample
    cards.delete(card)
    participant.cards_in_hand << card
  end
end

class Card
  attr_reader :suit, :num, :value
  def initialize(suit, num, value)
    @suit = suit
    @num = num
    @value = value
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    clear
    welcome_message
    loop do
      reset
      clear
      deal_initial_cards
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
    end
    goodbye_message
  end

  private

  def welcome_message
    puts "Welcome to Twenty One!"
    puts "What is your name?"
    player.name = gets.chomp.capitalize
    clear
  end

  def deal_initial_cards
    deck.deal(player)
    deck.deal(player)
    deck.deal(dealer)
    deck.deal(dealer)
  end

  def show_initial_cards
    player.show_cards
    puts ""
    puts "The dealer has:"
    puts "#{dealer.show_card(0)} and an unknown card"
    puts ""
  end

  def player_turn
    loop do
      break if player.busted?
      player.show_total
      break if player.stay?
      player.hit(deck)
      clear
      show_initial_cards
    end
  end

  def dealer_turn
    loop do
      dealer.hit(deck)
      break if dealer.total > 16
    end
  end

  def show_winner
    if dealer.busted?
      puts "You won!"
    elsif dealer.total > player.total
      puts "Dealer won!"
    elsif dealer.total < player.total
      puts "You won!"
    else
      puts "It's a tie"
    end
  end

  def show_result
    clear
    player.show_cards
    puts ""
    if player.busted?
      return player.show_total
    end
    dealer.show_cards
    puts ""
    player.show_total
    dealer.show_total
    show_winner
  end

  def clear
    system 'clear'
  end

  def play_again?
    answer = nil
    loop do
      puts ""
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    @deck = Deck.new
    player.clear_cards
    dealer.clear_cards
  end

  def goodbye_message
    puts ""
    puts "Thanks for playing Twenty One!"
  end
end

Game.new.start
