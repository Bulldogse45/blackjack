

class Card
  attr_accessor :face, :suit, :value

  def initialize(face, suit)
    self.face = face
    self.suit = suit
    if face == "ace"
      self.value =  11
    elsif face.to_i > 0
      self.value = face.to_i
    else
      self.value = 10
    end
  end
end
