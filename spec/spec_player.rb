require_relative "../lib/player.rb"

describe Player do
  player1 = Player.new("Johnny5", "white")
  describe "#initialize" do
    it "should have a player's name assigned" do
      expect(player.name).to eq("Johnny5")
    end

    it "should assign a color to match the player's game pieces" do
      expect(player.color).to eq("white")
    end

    it "should create an empty array for the player's past moves" do
      expect(player.previous_moves).to eq([])
    end
  end
end