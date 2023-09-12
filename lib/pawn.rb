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
        if current_game.board[i][j] && current_game.board[i][j].color != @color
          test_board = current_game.build_test_board
          current_game.move_piece(position, [i, j], test_board)
          unless current_game.king_in_check?(@color, test_board)
            @possible_moves.push(current_game.array_to_coords([i, j]))
          end
        end
        # check en passant
        next if current_game.move_log.length < 2
        last_move = current_game.move_log[-1]
        if last_move[2] == "Pawn"
          if last_move[1][0] + 2 == last_move[0][0] || last_move[1][0] - 2 == last_move[0][0]
            if @color == "white" && position[0] == 3
              if last_move[1] == [3, j]
                test_board = current_game.build_test_board
                current_game.move_piece(position, [i, j], test_board)
                unless current_game.king_in_check?(@color, test_board)
                  @possible_moves.push(current_game.array_to_coords([i, j]))
                end
              end
            elsif @color == "black" && position[0] == 4
              if last_move[1] == [4, j]
                test_board = current_game.build_test_board
                current_game.move_piece(position, [i, j], test_board)
                unless current_game.king_in_check?(@color, test_board)
                  @possible_moves.push(current_game.array_to_coords([i, j]))
                end
              end
            end
          end
        end
      end
    end
  end
end