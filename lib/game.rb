require_relative "king.rb"
require_relative "queen.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "rook.rb"
require_relative "pawn.rb"

class Game
  attr_reader :board
  def initialize()
    @board = [[Rook.new("black"),Knight.new("black"),Bishop.new("black"),Queen.new("black"),
              King.new("black"),Bishop.new("black"),Knight.new("black"),Rook.new("black")],
              [Pawn.new("black"),Pawn.new("black"),Pawn.new("black"),Pawn.new("black"),
              Pawn.new("black"),Pawn.new("black"),Pawn.new("black"),Pawn.new("black")],
              [nil,nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil,nil],
              [Pawn.new("white"),Pawn.new("white"),Pawn.new("white"),Pawn.new("white"),
              Pawn.new("white"),Pawn.new("white"),Pawn.new("white"),Pawn.new("white")],
              [Rook.new("white"),Knight.new("white"),Bishop.new("white"),Queen.new("white"),
              King.new("white"),Bishop.new("white"),Knight.new("white"),Rook.new("white")]]
  end

  def print_board()
    i = 0
    j = 0
    while i <= 16 do
      if i.even?
        puts
        puts "     - - - - - - - - - - - - - - -  "
      else
        case i
        when 1
          print " a "
        when 3
          print " b "
        when 5
          print " c "
        when 7
          print " d "
        when 9
          print " e "
        when 11
          print " f "
        when 13
          print " g "
        when 15
          print " h "
        end

        @board[j].each do |slot|
          print "| "
          if slot
            print "#{slot.symbol} "
          else
            print "  "
          end
        end
        print "|"
        j += 1
      end
      i += 1
    end
    puts "     1   2   3   4   5   6   7   8"
  end
end