class AllSync
  def self.update
    Clan.transaction do
      TankSync.update
      clan = ClanSync.update_clan_by_name('RDDT3')
      PlayerSync.update_members_in_clan(clan)
      PlayerSync.update_member_reddit_names_in_clan(clan)
      PlayerSync.update_resources_in_clan(clan)
      PlayerTanksSync.update_all_player_tanks
    end
  end
end
