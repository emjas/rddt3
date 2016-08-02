class Clan < ActiveRecord::Base
  ROLE_IDS = ['Commander', 'Executive Officer', 'Combat Officer', 'Intelligence Officer', 'Recruitment Officer', 'Junior Officer', 'Private', 'Recruit', 'Reservist']

  has_many :members
  has_many :players, through: :members

  def member_role_index(account_id)
    account = members.find_by(account_id: account_id)
    if account
      clan_role = account.role_i18n
      return ROLE_IDS.find_index{|role| role == clan_role}
    else
      return nil
    end
  end

  def member_role(account_id)
    account = members.find_by(account_id: account_id)
    if account
      return account.role_i18n
    else
      return nil
    end
  end

  def member_join_date(account_id)
    account = members.find_by(account_id: account_id)
    if account
      return account.created_at
    else
      return nil
    end
  end
end
