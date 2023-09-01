class Knight
  attr_reader :name, :color, :symbol
  attr_accessor :possible_moves
  def initialize(color)
    @name = "Knight"
    @color = color
    color == "white" ? (@symbol = "♞") : (@symbol = "♘")
    @possible_moves = []
  end
end