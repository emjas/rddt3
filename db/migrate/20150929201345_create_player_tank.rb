class CreatePlayerTank < ActiveRecord::Migration
  def change
    create_table :player_tanks, id: false do |t|
      t.integer :account_id
      t.integer :tank_id
    end
    reversible do |change|
      change.up do
        PlayerTank.connection.execute("ALTER TABLE player_tanks ADD PRIMARY KEY (account_id, tank_id)")
      end
    end
  end
end
