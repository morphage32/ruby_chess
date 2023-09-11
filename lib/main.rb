require_relative "player.rb"
require_relative "game.rb"

playing = 'f'
puts "Welcome to Ruby Chess!"

until playing == 'n' do
  current_game = Game.new()
  puts "Please enter a name for player 1 (white): "
  name = gets.chomp
  name = "Player 1" if name == ""
  current_game.player1 = Player.new(name, "white", current_game.board[7][4])
  puts "Please enter a name for player 2 (black): "
  name = gets.chomp
  name = "Player 2" if name == ""
  name += "-2" if name == current_game.player1.name
  current_game.player2 = Player.new(name, "black", current_game.board[0][4])
  current_game.player1.king.position = [7, 4]
  current_game.player2.king.position = [0, 4]

  current_game.print_board
  current_game.update_all_moves
  current_player = current_game.player1
  endgame = 0
  puts

  while endgame == 0 do
    starting_coords = ""
    start_array = []
    finishing_coords = ""
    finish_array = []

    until start_array.length == 2 && finish_array.length == 2 do
      puts "It's #{current_player.name}'s turn! Enter the letter and number of the piece you would like to move: "
      selected_square = nil
      starting_coords = gets.chomp.downcase
      start_array = current_game.coords_to_array(starting_coords)
      if start_array.length == 2
        selected_square = current_game.board[start_array[0]][start_array[1]]
      end
      if selected_square && selected_square.color == current_player.color
        if selected_square.possible_moves.length > 0
          until finish_array.length == 2 || finishing_coords == "cancel"
            puts "Please enter the letter and number of the square you would like to move your #{selected_square.name}, or type 'cancel' to select a different piece: "
            finishing_coords = gets.chomp.downcase
            if finishing_coords == "cancel"
              starting_coords = ""
              start_array = []
              finishing_coords = ""
              finish_array = []
              break
            end
            if selected_square.possible_moves.include?(finishing_coords)
              finish_array = current_game.coords_to_array(finishing_coords)
            else
              puts "Invalid selection, please try again."
            end
          end
        else
          puts "Your #{selected_square.name} has no possible moves. Please select another piece."
        end
      else
        puts "Invalid selection, please try again."
      end
    end
    current_game.move_piece(start_array, finish_array)
    if current_game.board[finish_array[0]][finish_array[1]].first_move
      current_game.board[finish_array[0]][finish_array[1]].first_move = false
    end
    if current_player.color == "white"
      current_player = current_game.player2
    else
      current_player = current_game.player1
    end
    current_game.update_all_moves
    current_game.print_board
  end
end