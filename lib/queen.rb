class Queen
  attr_reader :name, :color, :symbol
  attr_accessor :first_move, :possible_moves
  def initialize(color)
    @name = "Queen"
    @color = color
    color == "white" ? (@symbol = "♛") : (@symbol = "♕")
    @first_move = true
    @possible_moves = []
  end

  def update_moves(current_game, position)
    @possible_moves.clear
    all_moves = [[-1, 0],[1, 0],[0, -1],[0, 1],[-1, -1],[-1, 1],[1, 1],[1, -1]]

    all_moves.each do |move|
      i = position[0] + move[0]
      j = position[1] + move[1]
      while i >= 0 && j >= 0 && i < 8 && j < 8 do
        break if current_game.board[i][j] && current_game.board[i][j].color == @color
        test_board = current_game.build_test_board
        current_game.move_piece(position, [i, j], test_board)
        unless current_game.king_in_check?(@color, test_board)
          @possible_moves.push(current_game.array_to_coords([i, j]))
        end
        break if current_game.board[i][j]
        i += move[0]
        j += move[1]
      end
    end
  end
end