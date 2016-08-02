require 'rails_helper'

describe SoldierEligible do
  
  it "has equality where player and clan are the same" do
    clan = build(:clan)
    player = build(:player)
    expect(SoldierEligible.new(clan, player)).to eq(SoldierEligible.new(clan, player))
  end

  describe ".join_date?" do
    it "returns true if member_join_date more than one month ago" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 2.months.ago.to_i
      se = SoldierEligible.new(clan, player)
      expect(se.join_date?).to eq true
    end
    it "returns false if member_join_date less than one montha go" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 2.weeks.ago.to_i
      se = SoldierEligible.new(clan, player)
      expect(se.join_date?).to eq false
    end
  end

  describe ".resource_requirement?" do
    it "returns true if user has 500 or more resources in most recent RecordedResource" do
      clan = build(:clan_with_players)
      player = clan.players.first
      player.recorded_resources << build(:recorded_resource, count: 500)
      se = SoldierEligible.new(clan, player)
      expect(se.resource_requirement?).to eq true
    end
    it "returns false if user has less than 500 resources" do
      clan = build(:clan_with_players)
      player = clan.players.first
      player.recorded_resources << build(:recorded_resource, count: 499)
      se = SoldierEligible.new(clan, player)
      expect(se.resource_requirement?).to eq false
    end
    it "returns false if user has no recorded_resources" do
      clan = build(:clan_with_players)
      player = clan.players.first
      se = SoldierEligible.new(clan, player)
      expect(se.resource_requirement?).to eq false
    end
  end

  describe '.soldier_eligible?' do
    it "returns true if user meets all sub-requirements" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 2.months.ago.to_i
      player.recorded_resources << build(:recorded_resource, count: 500)
      tank = build(:tank, level: 8, is_premium: false)
      player_tank = build(:player_tank, player: player, tank: tank)
      SoldierEligible.tank_cache = [tank]
      se = SoldierEligible.new(clan, player)
      expect(se.soldier_eligible?).to eq true
    end
    it "returns false if user does not meet any sub-requirements" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 2.weeks.ago.to_i
      player.recorded_resources << build(:recorded_resource, count: 400)
      tank = build(:tank, level: 8, is_premium: true)
      player_tank = build(:player_tank, player: player, tank: tank)
      se = SoldierEligible.new(clan, player)
      expect(se.soldier_eligible?).to eq false
    end
  end

  describe "tank_cache" do
    it "initializes to Tanks.all.to_a if not otherwise set" do
      t = create(:tank)
      SoldierEligible.tank_cache = nil
      expect(SoldierEligible.tank_cache).to eq [t]
    end
    it "can be set to something else and retains that" do
      t = [1,2,3]
      SoldierEligible.tank_cache = t
      expect(SoldierEligible.tank_cache).to be t
    end
  end

end
