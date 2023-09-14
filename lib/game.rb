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
          print " 8 "
        when 3
          print " 7 "
        when 5
          print " 6 "
        when 7
          print " 5 "
        when 9
          print " 4 "
        when 11
          print " 3 "
        when 13
          print " 2 "
        when 15
          print " 1 "
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
    puts "     a   b   c   d   e   f   g   h"
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
    coords = [array[1], array[0]]
    coords[0] = (coords[0] + 97).chr
    coords[1] = (-(coords[1] - 7) + 49).chr
    return coords.join
  end

  def coords_to_array(string)
    return [] unless string.length == 2
    coords = string.split("")
    array = [coords[1], coords[0]]
    array[0] = (8 - array[0].to_i)
    array[1] = (array[1].ord - 97)
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

  def convert_pawn(piece, color, array) 
    case piece
    when "q"
      @board[array[0]][array[1]] = Queen.new(color)
    when "r"
      @board[array[0]][array[1]] = Rook.new(color)
    when "k"
      @board[array[0]][array[1]] = Knight.new(color)
    when "b"
      @board[array[0]][array[1]] = Bishop.new(color)
    end
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
                [-2, -1],[-2, 1],[-1, 2],[1, 2],[2, 1],[2, -1],[1, -2],[-1, -2]]
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
    # Search for checkmate / stalemate
    player = 1
    until player > 2 do
      i = 0
      j = 0
      no_moves = true
      while i < 8 && no_moves do
        while j < 8 do
          if player == 1 && board[i][j] && board[i][j].color == "white"
            if board[i][j].possible_moves.length > 0
              no_moves = false
              break
            end
          elsif player == 2 && board[i][j] && board[i][j].color == "black"
            if board[i][j].possible_moves.length > 0
              no_moves = false
              break
            end
          end
          j += 1
        end
        j = 0
        i += 1
      end
      if no_moves
        if player == 1
          if king_in_check?("white")
            return 2 # player 2 wins
          end
        else
          if king_in_check?("black")
            return 1 # player 1 wins
          end
        end
        return 4 # stalemate
      end
      player += 1
    end
    
  # endgames still needed:
  # threefold-repetition (code 3)
  # insufficient mating material (code 5)
  # forfeit (code 11 or 22)

    return 0
  end
end