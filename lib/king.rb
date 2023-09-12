class King
  attr_reader :name, :color, :symbol
  attr_accessor :first_move, :possible_moves, :position
  def initialize(color)
    @name = "King"
    @color = color
    color == "white" ? (@symbol = "♚") : (@symbol = "♔")
    @first_move = true
    @position
    @possible_moves = []
  end

  def update_moves(current_game, position)
    @possible_moves.clear
    all_moves = [[-1, 0],[1, 0],[0, -1],[0, 1],[-1, -1],[-1, 1],[1, 1],[1, -1]]

    all_moves.each do |move|
      i = position[0] + move[0]
      j = position[1] + move[1]
      next unless i >= 0 && j >= 0 && i < 8 && j < 8
      next if current_game.board[i][j] && current_game.board[i][j].color == @color
      test_board = current_game.build_test_board
      current_game.move_piece(position, [i, j], test_board)
      unless current_game.king_in_check?(@color, test_board, [i, j])
        @possible_moves.push(current_game.array_to_coords([i, j]))
      end
    end
    # add castling moves
    if @first_move
      i = position[0]
      unless current_game.king_in_check?(@color)
        row = current_game.board[i]
        if row[0] && row[0].first_move # queenside
          if row[1].nil? && row[2].nil? && row[3].nil?
            j = 3
            check = false
            while j > 1 do
              test_board = current_game.build_test_board
              current_game.move_piece(position, [i, j], test_board)
              check = current_game.king_in_check?(@color, test_board, [i, j])
              break if check
              j -= 1
            end
            @possible_moves.push(current_game.array_to_coords([i, j + 1])) unless check
          end
        end
        if row[7] && row[7].first_move # kingside
          if row[5].nil? && row[6].nil?
            j = 5
            check = false
            while j < 7 do
              test_board = current_game.build_test_board
              current_game.move_piece(position, [i, j], test_board)
              check = current_game.king_in_check?(@color, test_board, [i, j])
              break if check
              j += 1
            end
            @possible_moves.push(current_game.array_to_coords([i, j - 1])) unless check
          end
        end
      end
    end
  end
end