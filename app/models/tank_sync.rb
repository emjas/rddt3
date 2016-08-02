class TankSync

  def self.update
    tanks = WotApi::Base.encyclopedia_tanks
    Tank.transaction do
      tanks.each do |tank_id, tank|
        t = Tank.find_or_create_by(tank_id: tank_id)
        t.attributes = tank.reject{|k,v| !t.attributes.keys.member?(k.to_s) }
        t.save
      end
    end
  end

end
