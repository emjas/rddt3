module PlayerHelper

  def last_played_date_class(player)
    player.last_battle_time < 1.month.ago ? 'danger' : ''
  end

  def join_date_class(eligibility)
    eligibility.join_date? ? '' : 'danger'
  end

  def member_join_date_days(clan, player)
    (DateTime.now.to_i - clan.member_join_date(player.account_id).to_i) / 86400
  end

  def value_sub_nil(value, replace)
    !value.nil? ? value : replace
  end

end
