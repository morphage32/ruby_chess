class Player
  attr_reader :name, :color, :king
  def initialize(name, color, king)
    @name = name
    @color = color
    @king = king
    @previous_moves = []
  end
end