class PlayerTank < ActiveRecord::Base
  self.primary_keys = :account_id, :tank_id

  belongs_to :player, foreign_key: :account_id
  belongs_to :tank
end
