class CreatePlayer < ActiveRecord::Migration
  def change
    create_table :players, id: false do |t|
      t.integer :account_id, null: false
      t.string :nickname
      t.string :reddit_name
      t.datetime :last_battle_time
      t.datetime :created_at
    end
    reversible do |change|
      change.up do
        Player.connection.execute("ALTER TABLE players ADD PRIMARY KEY (account_id)")
      end
    end
  end
end
