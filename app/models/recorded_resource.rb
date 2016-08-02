class RecordedResource < ActiveRecord::Base
  #default_scope { where(deleted_at: nil) }

  self.primary_keys = :player_id, :created_at

  belongs_to :player

  before_save :set_slope

  def set_slope
    created_at = self.created_at.present? ? self.created_at : DateTime.now
    prev_rr = self.player(true).recorded_resources(true).where("created_at < ?", created_at).order(created_at: :desc).limit(1).first
    if prev_rr
      slope_prev = (self.count - prev_rr.count) / (created_at.to_f - prev_rr.created_at.to_f).to_f
      if slope_prev < 0
        self.player.recorded_resources.where("created_at < ?", created_at).destroy_all
        self.slope_prev = nil
      else
        self.slope_prev = slope_prev
      end
    end
  end

  def count_at_date(date)
    return nil if deleted_at
    return (count + ((date - created_at) * slope_prev)).round if slope_prev
    return nil
  end

  def self.player_report(players, dates)
    dates = [dates] if [DateTime, Time, Date, ActiveSupport::TimeWithZone].include? dates.class
    query = players.map do |player|
      dates.map do |date|
        '(' + self.select(:player_id, :created_at).where(player_id: player.account_id).where("created_at > ?", date).where(deleted_at: nil).order(created_at: :asc).limit(1).to_sql + ')'
      end
        .append('(' + self.select(:player_id, :created_at).where(player_id: player.account_id, deleted_at: nil).order(created_at: :desc).limit(1).to_sql + ')')
        .join(" UNION ALL ")
    end.join(" UNION ALL ")
    #find_by_sql(query)
    #self.where("(player_id, created_at) in (select * from((#{query})as subquery))")
    self.joins("inner join (#{query}) as subquery on recorded_resources.player_id = subquery.player_id and recorded_resources.created_at = subquery.created_at")
  end

  scope :within_month, -> { where("created_at > ?", 1.month.ago) }

  def self.process_input(input)
    results = input.split("\n").reject{|line| line.strip == ''}.map{|line| line.split("\t").map{|item| item.strip}}
    # do some validation
    if results.map{|r| r.count}.max != 5
      Rails.logger.debug('max not 5')
      return false
    end
    if results.map{|r| r.count}.min != 5
      Rails.logger.debug('min not 5')
      return false
    end
    if results.count < 2
      Rails.logger.debug('less than two results')
      return false
    end

    players = Player.all.to_a
    results.each do |result|
      player = players.find{|p| p.nickname == result[0]}
      if player
        player.recorded_resources << RecordedResource.new(count: result[4])
      end
    end

    return true
  end

end
