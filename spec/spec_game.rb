require_relative "../lib/game.rb"
require_relative "../lib/player.rb"
require_relative "../lib/king.rb"
require_relative "../lib/queen.rb"
require_relative "../lib/bishop.rb"
require_relative "../lib/rook.rb"
require_relative "../lib/knight.rb"
require_relative "../lib/pawn.rb"

describe Game do
  game1 = Game.new()
  game1.player1 = Player.new("Jill", "white", game1.board[7][4])
  game1.player1.king.position = [7, 4]
  game1.player2 = Player.new("Jack", "black", game1.board[0][4])
  game1.player2.king.position = [0, 4]
  game1.update_all_moves

  describe "#initialize" do
    it "should create an 8x8 board using nested arrays" do
      expect(game1.board.length).to eq(8)
      game1.board.each do |row|
        expect(row.length).to eq(8)
      end
    end
  end

  describe "#array_to_coords" do
    it "should take a 2-character string and return an array" do
      expect(game1.array_to_coords([0, 0])).to eq("a8")
      expect(game1.array_to_coords([4, 7])).to eq("h4")
    end
  end

  describe "#coords_to_array" do
    it "should take an array and return a coordinate string" do
      expect(game1.coords_to_array("a1")).to eq([7, 0])
      expect(game1.coords_to_array("d6")).to eq([2, 3])
    end
  end

  describe "#add_position" do
    it "should push a string that represents the gameboard into positions array" do
      game1.add_position("white")
      expect(game1.instance_variable_get(:@positions)[-1]).to eq(
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq --")
    end
  end

  game2 = Game.new()
  game2.player1 = Player.new("Jill", "white", game2.board[7][4])
  game2.player1.king.position = [7, 4]
  game2.player2 = Player.new("Jack", "black", game2.board[0][4])
  game2.player2.king.position = [0, 4]
  game2.update_all_moves


  describe "#move_piece" do
    game2.move_piece([7, 1], [5, 2])
    it "should move a game piece to the defined coordinates on the board" do
      expect(game2.board[5][2].name).to eq("Knight")
    end

    it "should make the starting slot nil after moving" do
      expect(game2.board[7][1]).to eq(nil)
    end
  end

  game3 = Game.new()
  game3.instance_variable_set(:@board, [[nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,King.new("black"),nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,King.new("white"),nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil]])
  game3.player1 = Player.new("Jill", "white", game3.board[5][5])
  game3.player2 = Player.new("Jack", "black", game3.board[3][3])
  game3.player1.king.position = [5, 5]
  game3.player2.king.position = [3, 3]


  describe "#king_in_check?" do
    it "should return false when not in check" do
      expect(game3.king_in_check?("white")).to be false
    end
  end
end