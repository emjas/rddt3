require 'rails_helper'

describe "Assumptions about the testing environment and tools" do

  it "lets me build related models without saving any of them" do
    clan = build(:clan)
    player = build(:player)
    clan.players << player
    expect(Player.count).to be 0
    expect(Clan.count).to be 0
  end

  it "saves children models when associated parent model is saved" do
    clan = create(:clan)
    player = build(:player)
    clan.players << player
    expect(Player.count).to be 1
    expect(Clan.count).to be 1
  end

  it "automatically associates parent with children when children has ID manually assigned" do
    clan = create(:clan)
    player = create(:player, clan_id: clan._id)
    expect(Player.count).to be 1
    expect(Clan.count).to be 1
    expect(Clan.first.players.count).to be 1
  end

  describe "players, player_tanks and tanks relationships" do
    it "allows me to build and not save each one of these in a relationship" do
      player = build(:player)
      tank = build(:tank)
      player_tank = build(:player_tank, player: player, tank: tank)
      Rails.logger.debug(player.inspect)
      Rails.logger.debug(player.player_tanks.inspect)
      Rails.logger.debug(player.player_tanks.map{|pt| pt.tank}.inspect)
      expect(player.player_tanks.first).to eq player_tank
      expect(player.player_tanks.first.tank).to eq tank
      expect(Player.count).to be 0
      expect(PlayerTank.count).to be 0
      expect(Tank.count).to be 0
    end
  end

end
