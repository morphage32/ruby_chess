require_relative "king.rb"
require_relative "queen.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "rook.rb"
require_relative "pawn.rb"

class Game
  attr_reader :board
  attr_accessor :player1, :player2

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
    @test_board = []
    @move_log = []
    @player1
    @player2
  end

  def build_test_board()
    @test_board.clear
    i = 0
    j = 0
    while i < 8 do
      @test_board.push([])
      while j < 8 do
        @test_board[i].push(@board[i][j])
        j += 1
      end
      i += 1
      j = 0
    end
    return @test_board
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

  def update_all_moves()
    i = 0
    j = 0
    while i < 8 do
      while j < 8 do
        if @board[i][j]
          @board[i][j].update_moves(self, [i, j])
        end
        j += 1
      end
      i += 1
      j = 0
    end
  end

  def array_to_coords(array)
    array[0] = (array[0] + 97).chr
    array[1] = (array[1] + 49).chr
    return array.join
  end

  def coords_to_array(string)
    return [] unless string.length == 2
    array = string.split("")
    array[0] = (array[0].ord - 97)
    array[1] = (array[1].to_i - 1)
    if array[0] >= 0 && array[0] >= 0 && array[1] < 8 && array[1] < 8
      return array
    else
      return []
    end
  end

  def move_piece(start, finish, current_board = @board)
    current_board[finish[0]][finish[1]] = current_board[start[0]][start[1]]
    current_board[start[0]][start[1]] = nil
  end

  def king_in_check?(color, current_board = @board)
    # STUBBED
    return false
  end

  def endgame_check()
    # STUBBED
    return 0
  end
end