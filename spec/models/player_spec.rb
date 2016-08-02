require 'rails_helper'

describe Player do

  it {is_expected.to be_a(Mongoid::Document)}
  it {is_expected.to be_a(Mongoid::Attributes::Dynamic)}
  it { is_expected.to belong_to(:clan) }
  it { is_expected.to embed_many(:player_tanks) }
  it { is_expected.to embed_many(:recorded_resources) }
  it { is_expected.to have_field(:fetched_at).of_type(DateTime) }
  it { is_expected.to have_field(:reddit_name).of_type(String) }

  it "sets _id to account_id" do
    player = build(:player)
    expect(player._id).to eq(player.account_id)
  end

  it "updates _id if account_id is also updated" do
    player = build(:player)
    player.account_id = 'hahaha'
    expect(player._id).to eq(player.account_id)
  end

  describe '.last_battle_time' do
    it "converts 'last_battle_time' attribute to a DateTime" do
      time = Time.now
      player = build(:player, last_battle_time: time.to_i)
      expect(player.last_battle_time).to eq Time.at(time.to_i).to_datetime
    end
  end

  describe '.lastest_recorded_resource' do
    it "returns the lastest recorded_resource" do
      player = build(:player)
      rr1 = build(:recorded_resource, created_at: 1.week.ago)
      rr2 = build(:recorded_resource, created_at: 2.weeks.ago)
      player.recorded_resources = [rr1,rr2]
      expect(player.latest_recorded_resource).to eq rr1
    end
  end

  describe '.latest_recorded_resource_count' do
    it "returns the count of the latest recorded_resource" do
      player = build(:player)
      rr1 = build(:recorded_resource, created_at: 1.week.ago)
      rr2 = build(:recorded_resource, created_at: 2.weeks.ago)
      player.recorded_resources = [rr1,rr2]
      expect(player.latest_recorded_resource_count).to eq rr1.count
    end
  end

  describe '.latest_recorded_resource_date' do
    it "returns the count of the latest recorded_resource" do
      player = build(:player)
      rr1 = build(:recorded_resource, created_at: 1.week.ago)
      rr2 = build(:recorded_resource, created_at: 2.weeks.ago)
      player.recorded_resources = [rr1,rr2]
      expect(player.latest_recorded_resource_date).to eq rr1.created_at
    end
  end

  describe '.last_played_date_class' do
    it "returns 'danger' if last_battle_time is more than 1 month ago" do
      player = build(:player, last_battle_time: 2.months.ago.to_i)
      expect(player.last_played_date_class).to eq 'danger'
    end
    it "returns '' if last_battle_Time is less than 1 month ago" do
      player = build(:player, last_battle_time: 3.weeks.ago.to_i)
      expect(player.last_played_date_class).to eq ''
    end
  end

  describe '.join_date_class' do
    it "returns 'danger' if join date is less than a month ago" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 2.weeks.ago.to_i
      expect(player.join_date_class).to eq 'danger'
    end
    it "returns '' if join date is more than a month ago" do
      clan = build(:clan_with_players)
      player = clan.players.first
      member = clan['members'][player.account_id]
      member['created_at'] = 5.weeks.ago.to_i
      expect(player.join_date_class).to eq ''
    end
  end

  describe '.resources_class' do
    it "returns 'danger' if user has less than 500 resources" do
      clan = build(:clan_with_players)
      player = clan.players.first
      player.recorded_resources << build(:recorded_resource, count: 400)
      expect(player.resources_class).to eq 'danger'
    end
    it "returns '' if user has more than 500 resources" do
      clan = build(:clan_with_players)
      player = clan.players.first
      player.recorded_resources << build(:recorded_resource, count: 501)
      expect(player.resources_class).to eq ''
    end
  end

  describe '.resources_at' do
    it "returns nil if there isn't a recorded_resource before and after the requested date" do
      player = build(:player)
      rr1 = build(:recorded_resource, created_at: 1.week.ago)
      player.recorded_resources = [rr1]
      expect(player.resources_at(2.weeks.ago)).to be_nil
    end
    it "returns an interpolated average value for recorded_resources" do
      player = build(:player)
      rr1 = build(:recorded_resource, created_at: 1.week.ago, count:200)
      rr2 = build(:recorded_resource, created_at: 2.weeks.ago, count:100)
      player.recorded_resources = [rr1,rr2]
      expect(player.resources_at(1.5.weeks.ago)).to eq 150
    end
  end

end
