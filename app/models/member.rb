class Member < ActiveRecord::Base
  self.primary_keys = :clan_id, :account_id

  belongs_to :clan
  belongs_to :player, foreign_key: :account_id
end
