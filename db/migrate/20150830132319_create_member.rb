class CreateMember < ActiveRecord::Migration
  def change
    create_table :members, id: false do |t|
      t.integer :clan_id
      t.integer :account_id
      t.datetime :created_at
      t.string :role
      t.string :role_i18n
    end
    reversible do |change|
      change.up do
        Member.connection.execute("ALTER TABLE members ADD PRIMARY KEY (clan_id, account_id)")
      end
    end
  end
end
