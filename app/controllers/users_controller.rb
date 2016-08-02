class UsersController < ApplicationController

  def index
    @users = Rails.cache.fetch('UsersController#index', expires_in: 6.hours, race_condition_ttl: 30) do
      rddt3 = Clan.new('rddt3')
      rddt3.members_with_reddit_names.sort{|x,y| y.last_battle_time <=> x.last_battle_time}
    end
  end

end
