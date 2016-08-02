class ClanSync
  def self.update_clan_by_name(clan_name)
    clan_id = clan_name_to_id(clan_name)
    clan_json = fetch_clan(clan_id)
    clan = nil
    Clan.transaction do
      clan = Clan.find_or_create_by(clan_id: clan_id)
      clan.attributes = clan_json.reject{|k,v| !clan.attributes.keys.member?(k.to_s) }
      clan.abbreviation = clan_json['tag']
      clan.save
      clan.members.destroy_all
      clan_json['members'].map do |member|
        memb = clan.members.find_or_create_by(account_id: member['account_id'])
        memb.attributes = member.reject{|k,v| !memb.attributes.keys.member?(k.to_s) }
        memb.created_at = Time.at(member['joined_at']).to_datetime
        memb.save
      end
    end
    clan
  end

  def self.clan_name_to_id(clan_name)
    clan_id = WotApi::Base.wgn_clans_list(search: clan_name.downcase).find{|c| c["tag"].downcase == clan_name.downcase}['clan_id'].to_s
  end

  def self.fetch_clan(clan_id)
    clan_data = WotApi::Base.wgn_clans_info(clan_id: clan_id)[clan_id]
  end
end
