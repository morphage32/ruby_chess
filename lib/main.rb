require_relative "player.rb"
require_relative "game.rb"

playing = 'f'
puts "Welcome to Ruby Chess!"

until playing == 'n' do
  current_game = Game.new()
  puts "Please enter a name for player 1 (white): "
  name = gets.chomp
  name = "Player 1" if name == ""
  player1 = Player.new(name, "white", current_game.board[7][4])
  puts "Please enter a name for player 2 (black): "
  name = gets.chomp
  name = "Player 2" if name == ""
  name += "-2" if name == player1.name
  player2 = Player.new(name, "black", current_game.board[0][4])

  current_game.print_board
  gets.chomp
end