class SoldierEligible
  attr_reader :clan, :player, :dates
  @@tank_cache = nil

  def initialize(clan, player, dates)
    @clan = clan
    @player = player
    @dates = dates
  end

  def join_date?(days=60)
    @clan.member_join_date(@player.account_id) < days.days.ago
  end

  def resource_requirement?(count=3000)
    @player.recorded_resources.count > 0 && @player.resource_report[:latest] >= count
  end

  def monthly_resource_requirement?
    @player.resource_report[:weekly][@dates.last.to_i].nil? || (@player.resource_report[:latest].to_i - @player.resource_report[:weekly][@dates.last.to_i].to_i) >= 300
  end

  def soldier_eligible?
    join_date?(60) && resource_requirement?(3000) && tank_requirement?([[3,8]])
  end

  def officer_eligible?
    join_date?(180) && resource_requirement?(10000) && tank_requirement?([[3,8],[1,10]])
  end

  def ==(other)
    @clan == other.clan && @player == other.player
  end

  def tank_requirement?(tiers)
    meets = true
    tiers.each do |count, tier|
      meets &&= (@player.tanks.where(level: tier).count >= count)
    end
    meets
  end

end
