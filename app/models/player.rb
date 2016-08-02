class Player < ActiveRecord::Base
  has_many :recorded_resources
  has_many :recorded_resources_report, class_name: "RecordedResource"

  has_one :member, foreign_key: :account_id # clan membership
  has_one :clan, through: :member

  has_many :player_tanks, foreign_key: :account_id
  has_many :tanks, through: :player_tanks

  attr_accessor :resource_report

  def self.prefetch_recorded_resources_report(players, dates)
    association_name = :recorded_resources_report

    rr = RecordedResource.player_report(players, dates)
    g = rr.group_by(&:player_id)

    players.each do |player|
      records = g[player.account_id].to_a

      if records
        association = player.association(association_name)
        association.loaded!
        association.target.concat(records)
        records.each { |record| association.set_inverse_instance(record) }
      end
    end
    return players
  end

  def self.with_resource_reports(players, dates)
    self.prefetch_recorded_resources_report(players, dates)

    players.each do |player|
      rr = player.recorded_resources_report.sort_by(&:created_at)
      report = {weekly: {}, weekly_diff: {}}
      report[:latest] = rr.last.count if rr.last
      prev_val = report[:latest]
      dates.each do |date|
        r = rr.find{|r| r.created_at >= date}
        if r
          value = r.count_at_date(date)
          if value
            report[:weekly][date.to_i] = value
            report[:weekly_diff][date.to_i] = prev_val - value if prev_val
            prev_val = value
          end
        end
        if date == dates.last && r && report[:latest] && v=r.count_at_date(date)
          report[:monthly] = report[:latest] - v
        end
      end
      player.resource_report = report
    end
    return players
  end

  def last_battle_time
    Time.at(self['last_battle_time']).to_datetime
  end
end
