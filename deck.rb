require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize(num_decks)
    self.cards = []
    num_decks.times do
      suits = %w[spades hearts diamonds clubs]
      faces = %w[2 3 4 5 6 7 8 9 10 jack queen king ace]

      faces.each do |face|
        suits.each do |suit|
          cards << Card.new(face, suit)
        end
      end
    end
    self.cards.shuffle!
  end
end
