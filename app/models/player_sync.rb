class PlayerSync

  def self.update_members_in_clan(clan)
    clan_member_ids = clan.members.map{|m| m.account_id}
    members = WotApi::Base.account_info(account_id: clan_member_ids.join(','))
    members.each do |account_id, member|
      player = Player.find_or_create_by(account_id: account_id)
      player.attributes = member.reject{|k,v| !player.attributes.keys.member?(k.to_s) }
      player.created_at = Time.at(member['created_at']).to_datetime
      player.last_battle_time = Time.at(member['last_battle_time']).to_datetime
      player.save
    end
  end

  def self.update_resources_in_clan(clan)
    clan_id = clan.clan_id
    begin
      results = WotApi::Base.clans_accounts(clan_id: clan_id)
      results.each do |result|
        player = Player.find(result['id'])
        if player
          player.recorded_resources.create(count: result['total_contribution'])
        end
      end
    rescue
    end
  end

  def self.update_member_reddit_names_in_clan(clan)
    members = clan.players.to_a
    begin
      client = RedditKit::Client.new 'rddt3_reddit_username', 'rddt3_reddit_password'
      flairs = client.flair_list('rddt3', limit: 1000)
      members.each do |member|
        flairs.each do |flair|
          if (flair.flair_text && flair.flair_text.include?(member.nickname)) || flair.user == member.nickname
            member.reddit_name = flair.user
            member.save
          end
        end
      end

      rddt_contributors = client.send(:get, "r/rddt3/about/contributors.json", limit: 100).body[:data][:children].map{|o| o[:name]} # call some private inner workings methods of RedditKit to do what we want
      members.each do |member|
        if rddt_contributors.include?(member.nickname) && !member.reddit_name
          member.reddit_name = member.nickname
          member.save
        end
      end

    rescue

    end
  end

end
