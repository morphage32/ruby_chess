require_relative "player.rb"
require_relative "game.rb"

playing = 'F'
puts "Welcome to Ruby Chess!"

until playing == 'N' do
  playing = "F"
  loading = "F"
  invalid = "Invalid selection, please try again."
  current_game = Game.new()
  current_game.add_position("white")
  save = File.open("lib/save.txt", "r")
  data = save.readlines.map(&:chomp)

  if data.length > 1
    until loading == "Y" || loading == "N" do
      puts
      puts "You have a saved game: #{data[0]} vs. #{data[1]}"
      puts "Would you like to resume? ('Y' for Yes, 'N' for No, 'D' to Delete): "
      loading = gets.upcase.chomp
      unless loading == "Y" || loading == "N" || loading == "D"
        puts invalid
      end
      if loading == "D"
        deleting = "F"
        puts "Deleting save game: #{data[0]} vs. #{data[1]}"
        puts "Are you sure? ('Y' for Yes, 'N' for No): "
        until deleting == "N" do
          deleting = gets.upcase.chomp
          unless deleting == "Y" || deleting == "N"
            puts invalid
          end
          if deleting == "Y"
            File.open("lib/save.txt", "w") {}
            loading = "N"
            break
          end
        end
      end
    end
  end

  if data[0] && loading == "Y"
    current_game.player1 = Player.new(data[0], "white", current_game.board[7][4])
    current_game.player2 = Player.new(data[1], "black", current_game.board[0][4])
    current_game.player1.king.position = [7, 4]
    current_game.player2.king.position = [0, 4]
    current_game.load_game(data)
    save.close
  else
    save.close
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
  end

  current_game.update_all_moves
  if current_game.move_log.length.even?
    current_player = current_game.player1
  else
    current_player = current_game.player2
  end
  current_game.print_board
  if current_game.king_in_check?(current_player.color)
    puts
    puts "#{current_player.name}'s King is in check!"
  end
  endgame = 0
  puts

  while endgame == 0 do
    starting_coords = ""
    start_array = []
    finishing_coords = ""
    finish_array = []

    until start_array.length == 2 && finish_array.length == 2 do
      puts "It's #{current_player.name}'s turn!"
      puts "Enter the letter and number of the piece you would like to move."
      puts "Type 'save' to save the game and quit."
      puts "Type 'resign' to forfeit the game."
      selected_square = nil
      starting_coords = gets.chomp.downcase
      start_array = current_game.coords_to_array(starting_coords)
      if start_array.length == 2
        selected_square = current_game.board[start_array[0]][start_array[1]]
      elsif starting_coords == "save" || starting_coords == "resign"
        if starting_coords == "save"
          saving = current_game.save_game
          if saving == "N"
            starting_coords = ""
            next
          end
          endgame = 6
          playing = 'N'
        else
          if current_player == current_game.player1
            endgame = 22
          else
            endgame = 11
          end
        end
        puts
        break
      end
      if selected_square && selected_square.color == current_player.color
        if selected_square.possible_moves.length > 0
          until finish_array.length == 2 || finishing_coords == "cancel"
            puts "Please enter the letter and number of the square you would like to move your #{selected_square.name}, or type 'cancel' to select a another option: "
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
              puts invalid
            end
          end
        else
          puts "Your #{selected_square.name} has no legal moves. Please select another piece."
        end
      else
        puts invalid
      end
    end
    break if endgame != 0
    current_game.move_piece(start_array, finish_array)
    current_game.move_log.push([start_array, finish_array, current_game.board[finish_array[0]][finish_array[1]].name])
    if current_game.board[finish_array[0]][finish_array[1]].first_move
      current_game.board[finish_array[0]][finish_array[1]].first_move = false
    end
    if current_game.board[finish_array[0]][finish_array[1]].name == "King"
      current_player.king.position = [finish_array[0], finish_array[1]]
    elsif current_game.board[finish_array[0]][finish_array[1]].name == "Pawn"
      if finish_array[0] == 0 || finish_array[0] == 7
        piece = ""
        puts "Your Pawn has reached its final rank! Promote it to a new piece!"
        puts "Enter 'q' for 'Queen','r' for 'Rook', 'k' for 'Knight', or 'b' for 'Bishop':"
        until piece.length == 1 && (piece == 'q' || piece == 'r' || piece == 'k' || piece == 'b') do
          piece = gets.downcase.chomp
          unless piece == 'q' || piece == 'r' || piece == 'k' || piece == 'b'
            puts invalid
          end
        end
        current_game.convert_pawn(piece, current_game.board[finish_array[0]][finish_array[1]].color, [finish_array[0], finish_array[1]])
      end
    end
    if current_player.color == "white"
      current_player = current_game.player2
    else
      current_player = current_game.player1
    end
    current_game.print_board
    puts
    current_game.update_all_moves
    current_game.add_position(current_player.color)
    endgame = current_game.endgame_check
    if current_game.king_in_check?(current_player.color) && endgame == 0
      puts "#{current_player.name}'s King is in check!"
      puts
    end
  end

  case endgame
  when 1
    puts "#{current_game.player1.name} has won the game! Reason: Checkmate"
  when 2
    puts "#{current_game.player2.name} has won the game! Reason: Checkmate"
  when 3
    puts "The game has ended in a draw. Reason: Threefold-Repetition"
  when 4
    puts "The game has ended in a draw. Reason: Stalemate"
  when 5
    puts "The game has ended in a draw. Reason: Insufficient Material"
  when 6
    puts "Your game has been saved"
    puts
  when 11
    puts "#{current_game.player1.name} has won the game! Reason: #{current_game.player2.name} has resigned"
  when 22
    puts "#{current_game.player2.name} has won the game! Reason: #{current_game.player1.name} has resigned"
  end

  until playing == "Y" || playing == "N" || endgame == 6 do
    puts "Would you like to play another game? (Y for 'Yes', N for 'No'): "
    playing = gets.upcase.chomp
    playing = "F" unless playing == "Y" || playing == "N"
  end
end