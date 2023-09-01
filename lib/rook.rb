class Rook
  attr_reader :name, :color, :symbol
  attr_accessor :possible_moves
  def initialize(color)
    @name = "Rook"
    @color = color
    color == "white" ? (@symbol = "♜") : (@symbol = "♖")
    @possible_moves = []
  end
end