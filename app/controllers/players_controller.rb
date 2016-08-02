class PlayersController < ApplicationController

  def index
    @dates = [1.week.ago, 2.weeks.ago, 3.weeks.ago, 4.weeks.ago]
    @clan = Clan.where(abbreviation: params[:clan_id]).first
    @players = Player.with_resource_reports(@clan.players, @dates).map{|player| [player, SoldierEligible.new(@clan, player, @dates)] }
  end

end
