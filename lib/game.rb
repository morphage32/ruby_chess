require_relative "king.rb"
require_relative "queen.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "rook.rb"
require_relative "pawn.rb"

class Game
  attr_reader :board
  attr_accessor :move_log, :player1, :player2

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
    # check for castling to move rook properly
    if current_board[start[0]][start[1]].name == "King"
      if finish[1] - 2 == start[1] || finish[1] + 2 == start[1]
        if finish[1] == 2
          move_piece([start[0], 0], [finish[0], 3], current_board)
        else
          move_piece([start[0], 7], [finish[0], 5], current_board)
        end
      end
    # check for en passant condition to delete out-of-place pawn
    elsif current_board[start[0]][start[1]].name == "Pawn"
      if start[1] + 1 == finish[1] || start[1] - 1 == finish[1]
        if current_board[finish[0]][finish[1]].nil?
          current_board[start[0]][finish[1]] = nil
        end
      end
    end
    current_board[finish[0]][finish[1]] = current_board[start[0]][start[1]]
    current_board[start[0]][start[1]] = nil
  end

  def king_in_check?(color, current_board = @board, custom_position = nil)
    # assign king
    if color == "white"
      current_king = player1.king
      i = -1
    else
      current_king = player2.king
      i = 1
    end

    j = 1
    if custom_position
      y = custom_position[0]
      x = custom_position[1]
    else
      y = current_king.position[0]
      x = current_king.position[1]
    end

    # look for diagonal pawns threatening check
    if y + i >= 0 && y + i < 8
      if x - j >= 0 && x - j < 8
        if current_board[y + i][x - j] && current_board[y + i][x - j].name == "Pawn" &&
          current_board[y + i][x - j].color != color
          return true
        end
      end
      if x + j >= 0 && x + j < 8
        if current_board[y + i][x + j] && current_board[y + i][x + j].name == "Pawn" &&
          current_board[y + i][x + j].color != color
          return true
        end
      end
    end

    all_moves = [[-1, 0],[1, 0],[0, -1],[0, 1],[-1, -1],[-1, 1],[1, 1],[1, -1],
                [-2, -1],[-2, 1],[-1, 2],[1, 2],[2, 1],[2, -1],[1, -2],[-1, 2]]
    a = 0 # index for "all_moves" array

    # look for opposing king
    until a > 7 do
      move = all_moves[a]
      i = y + move[0]
      j = x + move[1]
      unless i >= 0 && j >= 0 && i < 8 && j < 8
        a += 1
        next
      end
      if current_board[i][j] && current_board[i][j].name == "King"
        return true
      end
      a += 1
    end

    # look horizontally and vertically for opposing rooks / queens
    a = 0
    until a > 3 do
      move = all_moves[a]
      i = move[0]
      j = move[1]
      while y + i >= 0 && x + j >= 0 && y + i < 8 && x + j < 8 do
        if current_board[y + i][x + j] && current_board[y + i][x + j].color != color
          if current_board[y + i][x + j].name == "Rook" || current_board[y + i][x + j].name == "Queen"
            return true
          end
        end
        break if current_board[y + i][x + j]
        i += move[0]
        j += move[1]
      end
      a += 1
    end

    # look at each diagonal path for opposing bishops / queens
    until a > 7 do
      move = all_moves[a]
      i = move[0]
      j = move[1]
      while y + i >= 0 && x + j >= 0 && y + i < 8 && x + j < 8 do
        if current_board[y + i][x + j] && current_board[y + i][x + j].color != color
          if current_board[y + i][x + j].name == "Bishop" || current_board[y + i][x + j].name == "Queen"
            return true
          end
        end
        break if current_board[y + i][x + j]
        i += move[0]
        j += move[1]
      end
      a += 1
    end

    # look for threatening knights
    until a > 15 do
      move = all_moves[a]
      i = y + move[0]
      j = x + move[1]
      unless i >= 0 && j >= 0 && i < 8 && j < 8
        a += 1
        next
      end
      if current_board[i][j] && current_board[i][j].name == "Knight" &&
        current_board[i][j].color != color
        return true
      end
      a += 1
    end

    return false
  end

  def endgame_check()
    # STUBBED
    return 0
  end
end