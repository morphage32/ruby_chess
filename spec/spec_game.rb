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
  player1 = Player.new("Jill", "white", game1.board[7][4])
  player2 = Player.new("Jack", "black", game1.board[0][4])
  game1.update_all_moves

  describe "#initialize" do
    xit "should create an 8x8 board using nested arrays" do
      expect(game1.board.length).to eq(8)
      game1.board.each do |row|
        expect(row.length).to eq(8)
      end
    end

    xit "should fill the top and bottom two rows with player pieces" do
      i = -2
      until i > 2 do
        unless i == 0
          game1.board[i].each do |slot|
            expect(slot.nil?).to be false
          end
        end
        i += 1
      end
    end

    xit "should have empty slots in the middle four rows" do
      i = 3
      until i > 6 do
        game1.board[i].each do |slot|
          expect(slot.nil?).to be true
        end
        i += 1
      end
    end
  end

  describe "#valid_move?" do
    context "when the selected piece does not have a matching possible move" do
      xit "should return false" do
        expect(game1.valid_move?(player1, "h2", "f2")).to be false
      end
    end

    context "when the selected piece has a matching possible move" do
      xit "should return true" do  
        expect(game1.valid_move?(player1, "h2", "f1")). to be true
      end
    end

    game1.instance_variable_set("@board", [[Rook.new("black"),nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [Rook.new("white"),nil,nil,nil,King.new("white"),nil,nil,nil]])
    game1.update_all_moves

    context "when a piece is moved to a slot occupied by an opponent's piece" do
      xit "should return true" do
        expect(game1.valid_move?(player2, "a1", "h1")).to be true
      end
    end

    game1.instance_variable_set("@board", [[Rook.new("black"),nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [Pawn.new("black"),nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [Rook.new("white"),nil,nil,nil,King.new("white"),nil,nil,nil]])
    game1.update_all_moves

    context "when a piece is moved to a slot occupied by a piece of the same color" do
      xit "should return false" do
        expect(game1.valid_move?(player2, "a1", "c1")).to be false
      end
    end

    game1.instance_variable_set("@board", [[nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,Knight.new("white"),nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,Knight.new("black"),nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    game1.update_all_moves

    context "when the current player is in check" do
      xit "should return false when a move will not get the player out of check" do
        expect(game1.valid_move?(player2, "d6", "f7")).to be false
      end

      xit "should return true when the move will get the player out of check" do
        expect(game1.valid_move?(player2, "d6", "c4")).to be true
      end
    end
  end

  game1.instance_variable_set("@board", [[Rook.new("black"),nil,nil,nil,King.new("black"),nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,Bishop.new("white"),nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
  describe "#move_piece" do
    game1.move_piece(game1.board[3][3], game1.board[0][0])
    xit "should move the piece at the starting slot to the ending slot on the board" do
      expect(game1.board[0][0].name).to eq("Bishop")
      expect(game1.board[0][0].color).to eq("white")
    end

    xit "should make the starting slot empty after moving the piece" do
      expect(game1.board[3][3]).to be_nil
    end
  end

  game1.instance_variable_set("@board", [[nil,nil,Pawn.new("white"),nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,nil,nil,nil,nil],
                                        [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])

  describe "#convert_pawns" do
    xit "should create a new piece to replace the pawn on the board" do
      allow(described_class).to receive(:puts).and_return("")
      allow(described_class).to receive(:gets).and_return("queen")
      expect(game1.board[0][2].name).to eq("Queen")
    end
  end
  
  describe "#update_all_moves" do
    game1.instance_variable_set("@board", [[nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,Queen.new("black"),nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    game1.update_all_moves
    xit "should update each piece's possible_moves array" do
      expect(game1.board[1][4].possible_moves).to eq(["a4","a5","a6","b4","b6","c4","c5","c6"])
      expect(game1.board[2][1].possible_moves).to eq(["b2","a2","d2","e2","f2","g2","h2","c1",
                                                            "c3","c4","c5","c6","c7","c8","b1","b3","a4",
                                                            "d1","d3","e4","f5","g6","h7"])
      expect(game1.board[7][4].possible_moves).to eq(["g4","g5","g6","h4","h6"])
    end

    game1.instance_variable_set("@board", [[nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,Queen.new("white"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    game1.update_all_moves
    xit "should limit the amount of possible moves when a player's king is in check" do
      expect(game1.board[1][4].possible_moves).to eq(["a4","a6","b4","b6"])
    end
  end

  describe "#king_in_check?" do
    game1.instance_variable_set("@board", [[nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,Queen.new("white"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    xit "should return false when the selected player's color is not in check" do
      expect(game1.king_in_check?(player1, @game1.board)).to be false
    end

    xit "should return true when the selected player's king is in check" do
      expect(game1.king_in_check?(player2, @game1.board)).to be true
    end
  end

  describe "search_for_endgame" do
    game2 = Game.new()
    game2.update_all_moves
    xit "should return 0 when the game is not yet over" do
      expect(game2.search_for_endgame(player1, player2)).to eq(0)
    end

    game2.instance_variable_set("@board", [[nil,Rook.new("white"),nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,Queen.new("white"),nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    game2.update_all_moves

    xit "should return 1 when the game ends in checkmate" do
      expect(game2.search_for_endgame(player1, player2)).to eq(1)
    end

    game2.instance_variable_set("@board", [[nil,nil,nil,nil,King.new("black"),nil,nil,nil],
                                          [nil,Rook.new("white"),nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,Queen.new("white"),nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,nil,nil,nil,nil],
                                          [nil,nil,nil,nil,King.new("white"),nil,nil,nil]])
    game2.update_all_moves

    xit "should return 2 when the game ends in a stalemate" do
      expect(game2.search_for_endgame(player1, player2)).to eq(2)
    end
    
    game3 = Game.new()
    player1.instance_variable_set("@previous_moves", []) #update after implementation

    xit "should return 3 when the game draws due to threefold repetition" do
      expect(game3.search_for_endgame(player1, player2)).to eq(3)
    end
  end
end