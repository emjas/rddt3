require 'rails_helper'

describe Clan do

  it {is_expected.to be_a(Mongoid::Document)}
  it {is_expected.to be_a(Mongoid::Attributes::Dynamic)}
  it { is_expected.to have_many(:players) }
  it { is_expected.to have_field(:fetched_at).of_type(DateTime) }

  it "sets _id to clan_id" do
    clan = build(:clan)
    expect(clan._id).to eq(clan.clan_id)
  end

  it "updates _id if clan_id is also updated" do
    clan = build(:clan)
    clan.clan_id = 'hahaha'
    expect(clan._id).to eq(clan.clan_id)
  end

  it "has players if specified" do
    clan = create(:clan_with_players)
    expect(clan.players.length).to be 1
    clan = create(:clan_with_players, players_count: 20)
    expect(clan.players.length).to be 20
  end

  it "has ROLE_IDS class attribute array" do
    expect(Clan::ROLE_IDS).to be_a(Array)
  end

  describe ".member_role_value" do
    it "returns 0 for a Commander member" do
      clan = build(:clan_with_commander_member)
      member = clan.players.first
      expect(clan.member_role_value(member.account_id)).to eq 0
    end
  end

  describe ".member_role" do
    it "returns 'Commander' for a commander member" do
      clan = build(:clan_with_commander_member)
      member = clan.players.first
      expect(clan.member_role(member.account_id)).to eq "Commander"
    end
  end

  describe ".member_join_date" do
    it "returns a DateTime" do
      clan = build(:clan_with_players)
      member = clan.players.first
      member_date = Time.at(clan['members'][member.account_id]['created_at']).to_datetime
      expect(clan.member_join_date(member.account_id)).to eq member_date
    end
  end

end
