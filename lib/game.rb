require_relative "king.rb"
require_relative "queen.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "rook.rb"
require_relative "pawn.rb"

class Game
  attr_reader :board, :positions
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
    @positions = []
    @player1
    @player2
  end

  def load_game(data)
    i = 2
    while i < data.length do
      move = data[i].split("")
      j = 0
      while j < 4 do
        move[j] = move[j].to_i
        j += 1
      end
      start = [move[0], move[1]]
      finish = [move[2], move[3]]
      move_piece(start, finish)
      @move_log.push([start, finish, @board[move[2]][move[3]].name])
      if @board[move[2]][move[3]].first_move == true
        @board[move[2]][move[3]].first_move = false
      end
      if @board[move[2]][move[3]].name == "King"
        @board[move[2]][move[3]].position = [move[2], move[3]]
      elsif move[4]
        convert_pawn(move[4], @board[move[2]][move[3]].color, finish)
      end
      i += 1
    end
  end

  def save_game()
    save = File.open("lib/save.txt", "r+")

    unless save.size == 0
      saving = "F"
      p1 = save.readline.chomp
      p2 = save.readline.chomp
      puts "You currently have a saved game. (#{p1} vs. #{p2})"
      puts "Overwrite saved game? ('Y' for Yes, 'N' for No):"
      until saving == "Y" do
        saving = gets.upcase.chomp
        if saving == "N"
          save.close
          return saving
        end
        unless saving == "Y"
          puts "Invalid selection. Please try again."
        end
      end
    end

    save.truncate(0)
    save.write("#{@player1.name}\n")
    save.write("#{@player2.name}")

    @move_log.each do |move|
      save.write("\n#{move[0][0]}#{move[0][1]}#{move[1][0]}#{move[1][1]}")
      if move[3]
        save.write("#{move[3]}")
      end
    end
    save.close
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

  def add_position(color)
    string = ""
    i = 0
    j = 0
    empty = 0

    while i < 8 do
      while j < 8 do
        if @board[i][j].nil?
          empty += 1
        else
          if empty > 0
            string += empty.to_s
            empty = 0
          end
          if @board[i][j].name == "Pawn" && @board[i][j].color == "white"
            string += "P"
          elsif @board[i][j].name == "Knight" && @board[i][j].color == "white"
            string += "N"
          elsif @board[i][j].name == "Bishop" && @board[i][j].color == "white"
            string += "B"
          elsif @board[i][j].name == "Rook" && @board[i][j].color == "white"
            string += "R"
          elsif @board[i][j].name == "Queen" && @board[i][j].color == "white"
            string += "Q"
          elsif @board[i][j].name == "King" && @board[i][j].color == "white"
            string += "K"
          elsif @board[i][j].name == "Pawn"
            string += "p"
          elsif @board[i][j].name == "Knight"
            string += "n"
          elsif @board[i][j].name == "Bishop"
            string += "b"
          elsif @board[i][j].name == "Rook"
            string += "r"
          elsif @board[i][j].name == "Queen"
            string += "q"
          else
            string += "k"
          end
        end
        j += 1
      end
      if empty > 0
        string += empty.to_s
        empty = 0
      end
      i += 1
      j = 0
      string += "/" unless i == 8
    end

    string += " "
    string += color[0]
    string += " "

    if @board[7][4] && @board[7][4].first_move == true
      if @board[7][7] && @board[7][7].first_move == true
        string += "K"
      end
      if @board[7][0] && @board[7][0].first_move == true
        string += "Q"
      end
    end
    if @board[0][4] && @board[0][4].first_move == true
      if @board[0][7] && @board[0][7].first_move == true
        string += "k"
      end
      if @board[0][0] && @board[0][0].first_move == true
        string += "q"
      end
    end

    string += " "

    unless @move_log.empty?
      if @move_log[-1][2] == "Pawn"
        if @move_log[-1][1][0] + 2 == @move_log[-1][0][0] || @move_log[-1][1][0] - 2 == @move_log[-1][0][0]
          string += array_to_coords([(@move_log[-1][0][0] + @move_log[-1][1][0]) / 2, @move_log[-1][1][1]])
        else
          string += "--"
        end
      else
        string += "--"
      end
    else
      string += "--"
    end

    @positions.push(string)
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
    @board[array[0]][array[1]].first_move = false
    @move_log[-1].push(piece)
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

    if @positions.length > 4
      i = 0
      reps = 1
      until i == @positions.length - 1 do
        j = i + 1
        until j == @positions.length do
          if @positions[i] == @positions[j]
            reps += 1
          end
          if reps == 3
            return 3
          end
          j += 1
        end
        i += 1
        reps = 1
      end
    end

    i = 0
    j = 0
    white_pieces = []
    black_pieces = []
    possible_mate = false

    until possible_mate || i > 7 do
      while j < 8 do
        if @board[i][j]
          if @board[i][j].name == "Rook" || @board[i][j].name == "Queen" || 
            @board[i][j].name == "Pawn"
            possible_mate = true
            break
          else
            piece = @board[i][j].name
            if piece == "Bishop"
              if i.even?
                if j.even?
                  piece += "w"
                else
                  piece += "b"
                end
              else
                if j.even?
                  piece += "w"
                else
                  piece += "b"
                end
              end
            end
          end
          if @board[i][j].color == "white"
            white_pieces.push(piece)
          else
            black_pieces.push(piece)
          end
        end
        j += 1
      end
      i += 1
      j = 0
    end

    unless possible_mate
      if white_pieces.length < 3 && black_pieces.length < 3
        return 5
      else
        if white_pieces.count("Knight") == 2
          if black_pieces.length == 1
            return 5
          end
        elsif black_pieces.count("Knight") == 2
          if white_pieces.length == 1
            return 5
          end
        end
        if white_pieces.count("Knight") == 0 && black_pieces.count("Knight") == 0
          if white_pieces.include?("Bishopw") || black_pieces.include?("Bishopw")
            unless white_pieces.include?("Bishopb") || black_pieces.include?("Bishopb")
              return 5
            end
          end
        end
      end
    end

    return 0
  end
end