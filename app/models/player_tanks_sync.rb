class PlayerTanksSync

  def self.update_all_player_tanks
    all_player_ids = Player.pluck(:account_id)
    all_player_ids.each_slice(100) do |player_ids|
      member_tanks = WotApi::Base.account_tanks(account_id: player_ids.join(','))
      PlayerTank.transaction do
        member_tanks.each do |member_id, mts|
          if !mts.nil?
            mts.each do |member_tank|
              player_tank = PlayerTank.find_or_create_by(account_id: member_id, tank_id: member_tank['tank_id'])
              player_tank.save
            end
          end
        end
      end
    end
  end

end
