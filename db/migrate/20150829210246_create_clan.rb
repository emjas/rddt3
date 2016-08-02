class CreateClan < ActiveRecord::Migration
  def change
    create_table :clans, id: false do |t|
      t.integer :clan_id, null: false
      t.string :abbreviation
    end
    reversible do |change|
      change.up do
        Clan.connection.execute("ALTER TABLE clans ADD PRIMARY KEY (clan_id)")
      end
    end
  end
end
