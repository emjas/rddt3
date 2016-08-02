class Tank < ActiveRecord::Base
  has_many :player_tanks
end
