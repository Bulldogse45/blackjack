require_relative 'deck'
require_relative 'card'

class Blackjack

  attr_accessor :shoe, :dealer_cards, :dealer_score, :player_cards, :player_score, :house_wins, :player_wins, :sitting, :game_active
#this is an unnecessary  comment
  def initialize
    self.sitting = true
    self.player_wins = 0
    self.house_wins = 0
    self.shoe = Deck.new(6)
    self.dealer_cards = []
    self.player_cards = []
  end

  def reset

    self.dealer_cards = []
    self.player_cards = []
  end
#This comment is unnecessary
  def game
    puts "Welcome to Matt's Casino!"
    while sitting
      self.game_active = true
        while game_active
        puts "Press [enter] to play some Blackjack!"
        gets.chomp
        deal_cards
        if check_for_blackjack?(dealer_cards)
          puts "The dealer shows the #{dealer_cards[0].face} of #{dealer_cards[0].suit} and #{dealer_cards[1].face} of #{dealer_cards[1].suit}"
          puts "DEALER BLACKJACK!  You lose!"
          self.house_wins+=1
          reset
          keep_playing
        elsif check_for_blackjack?(player_cards)
          puts "You have the:"
            self.player_cards.each {|card| puts "       #{card.face} of #{card.suit}"}
          puts "PLAYER BLACKJACK! You win!"
          self.player_wins+=1
          reset
          keep_playing
        else
          check_for_aces
          player_choice
          check_player_card_count
          check_for_bust
          if player_cards.length > 0
            dealer_show_cards
            dealer_action
            check_winner
            reset
          end
          shuffling
          keep_playing
        end
      end
    end
  end

  def deal_cards
    2.times do
      self.dealer_cards << self.shoe.cards.shift
      self.player_cards << self.shoe.cards.shift
    end
    puts "The Dealer is showing the #{dealer_cards[0].face} of #{dealer_cards[0].suit}"
  end
  def player_choice
    choosing = true
    current_hand
    while choosing && calc_score(player_cards) <= 21 && player_cards.length < 6
      puts "Would you like to (h)it or (s)tay?"
      response = gets.chomp
      if response =="h"
        self.player_cards << self.shoe.cards.shift
        current_hand
        check_for_aces
      elsif response =="s"
        choosing = false
      else puts "please choose 'h' for hit or 's' for stay"
      end

    end
  end

  def calc_score(whose_cards)
    score = whose_cards.inject(0){|sum, card| sum + card.value}
  end

  def current_hand
    puts "You have the:"
    self.player_cards.each {|card| puts "       #{card.face} of #{card.suit}"}
    puts "your total is #{calc_score(player_cards)} and the dealer is showing the #{dealer_cards[0].face} of #{dealer_cards[0].suit}"
  end

  def dealer_action
    while calc_score(dealer_cards)<= 21 && calc_score(dealer_cards) < 16
      if calc_score(dealer_cards) < 16
        puts "the dealer must hit!  Press [enter] to see the next card!"
        gets.chomp
        self.dealer_cards << self.shoe.cards.shift
        dealer_show_cards
      end
    end
  end

  def dealer_show_cards
    puts "The dealer has the:"
      self.dealer_cards.each {|card| puts "#{card.face} of #{card.suit}"}
      puts "The dealer's total is #{calc_score(dealer_cards)} to your #{calc_score(player_cards)}"
  end

  def check_winner
    if calc_score(dealer_cards) > 21
      puts "DEALER BUSTED! Everyone left is a winner!"
      self.player_wins+=1
    elsif calc_score(dealer_cards) > calc_score(player_cards)
      puts "The dealer's #{calc_score(dealer_cards)} beats your #{calc_score(player_cards)}"
      self.house_wins+=1
    elsif  calc_score(player_cards) > calc_score(dealer_cards)
      puts "The player's #{calc_score(player_cards)} beats the dealer's #{calc_score(dealer_cards)}.  YOU WIN!"
      self.player_wins+=1
    elsif dealer_cards.length > player_cards.length
      puts "We tied! But since the dealer has #{dealer_cards.length} cards and you only have #{player_cards.length} cards YOU LOSE!"
      self.house_wins+=1
    elsif  player_cards.length > dealer_cards.length
      puts "We tied! But since the you have #{player_cards.length} cards and I only have #{dealer_cards.length} cards YOU WIN!"
      self.player_wins+=1
    else
      puts "We tied and both have #{dealer_cards.length}!  My casino is generous so YOU WIN!"
      self.player_wins+=1
    end
  end

  def check_for_blackjack?(whose_cards)
    true if calc_score(whose_cards) == 21
  end

  def check_player_card_count
    if player_cards.length >=6 && calc_score(player_cards) <= 21
      puts "YOU HAVE 6 LIVE CARDS!  YOU WIN!"
      self.player_wins+=1
      self.game_active = false
      reset
    end
  end

  def check_for_bust
    if calc_score(player_cards)>21
      puts "YOU BUSTED!  Matt's Casino thanks you for your donation!"
      self.house_wins+=1
      self.game_active = false
      reset
    end
  end
  def keep_playing
    puts "The house has won #{house_wins} hands and you have won #{player_wins} hands"
    self.game_active = false
    valid_response = false
    puts "Would you like to keep playing? 'y' or 'n'"
    until valid_response
      response = gets.chomp
      if response == "n"
        self.sitting = false
        valid_response = true
      elsif response == "y"
        system("clear")
        puts "Let's play again!"
        valid_response = true
      else
        puts "Please give a response of 'y' or 'n'"
      end
    end
  end

  def check_for_aces
    if player_cards.select{|c| c.face == "ace"}.length >= 1
      player_cards.each do |card|
        if card.face == "ace"
          response = ""
          puts "You have the:"
          self.player_cards.each {|card| puts "   #{card.face} of #{card.suit} "}
          puts "Would you like your Ace to be worth '11' or '1'?"
          until response == "11" || response == "1"
            response = gets.chomp
            if response == "11" || response =="1"
              puts "Your ace is now worth #{response}"
              card.value = response.to_i
            else
            puts "please respond with '11' or '1'."
            end
          end
        end
      end
    end
  end
  def shuffling
    if shoe.cards.length < 52
      puts "SHUFFLING!"
      self.shoe = Deck.new(6)
    end
  end
end

Blackjack.new.game
