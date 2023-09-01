class King
  attr_reader :name, :color, :symbol
  attr_accessor :possible_moves, :in_check
  def initialize(color)
    @name = "King"
    @color = color
    color == "white" ? (@symbol = "♚") : (@symbol = "♔")
    @in_check = false
    @possible_moves = []
  end
end