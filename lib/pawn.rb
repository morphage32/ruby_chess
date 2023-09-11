require_relative "game.rb"

class Pawn
  attr_reader :name, :color, :symbol
  attr_accessor :first_move, :possible_moves
  def initialize(color)
    @name = "Pawn"
    @color = color
    color == "white" ? (@symbol = "♟") : (@symbol = "♙")
    @first_move = true
    @possible_moves = []
  end

  def update_moves(current_game, position)
    @possible_moves.clear
    if @color == "white"
      all_moves = [[-1, 0],[-1, -1],[-1, 1]]
    else
      all_moves = [[1, 0],[1, -1],[1, 1]]
    end

    all_moves.each do |move|
      i = position[0] + move[0]
      j = position[1] + move[1]
      if move[1] == 0
        next if current_game.board[i][j]
        test_board = current_game.build_test_board
        current_game.move_piece(position, [i, j], test_board)
        unless current_game.king_in_check?(@color, test_board)
          @possible_moves.push(current_game.array_to_coords([i, j]))
        end
        if @first_move == true
          i += move[0]
          next if current_game.board[i][j]
          test_board = current_game.build_test_board
          current_game.move_piece(position,[i, j], test_board)
          unless current_game.king_in_check?(@color, test_board)
            @possible_moves.push(current_game.array_to_coords([i, j]))
          end
        end
      else
        # add checks for en passant
        next unless current_game.board[i][j] && current_game.board[i][j].color != @color
        test_board = current_game.build_test_board
        current_game.move_piece(position, [i, j], test_board)
        unless current_game.king_in_check?(@color, test_board)
          @possible_moves.push(current_game.array_to_coords([i, j]))
        end
      end
    end
  end
end