require 'rails_helper'

describe ClanSync do
  describe "#update_clan" do
    it "allows you to update twice with upsert" do
      clan_json = JSON.parse(File.open('spec/fixtures/clan.json','r'){|f| f.read})
      clan_json = clan_json[clan_json.keys.first]
      c = Clan.new(clan_json)
      c2 = Clan.new(clan_json)
      expect { ClanSync.update_clan(c); ClanSync.update_clan(c2) }.not_to raise_error
    end
    it "creates equivalent Clan objects with multiple upserts" do
      clan_json = JSON.parse(File.open('spec/fixtures/clan.json','r'){|f| f.read})
      clan_json = clan_json[clan_json.keys.first]
      c = Clan.new(clan_json)
      c2 = Clan.new(clan_json)
      ClanSync.update_clan(c)
      ClanSync.update_clan(c2)
      expect(c).to eq c2
    end
  end

  describe "#fetch_clan" do
    it "returns a JSON blob representing the clan" do
      clan_json = JSON.parse(File.open('spec/fixtures/clan.json','r'){|f| f.read})
      expect(WotApi::Base).to receive(:clan_info).and_return(clan_json)
      expect(ClanSync.fetch_clan(clan_json.keys.first)).to eq clan_json[clan_json.keys.first]
    end
  end

  describe "#clan_name_to_id" do
    it "returns a JSON blog representing the clan name" do
      clan_list = JSON.parse(File.open('spec/fixtures/clan_list.json','r'){|f| f.read})
      expect(WotApi::Base).to receive(:clan_list).and_return(clan_list)
      expect(ClanSync.clan_name_to_id('RDDT3')).to eq clan_list.first['clan_id'].to_s
    end
  end

  #describe "#update_clan_by_name" do
  #  it "
  #end
end
