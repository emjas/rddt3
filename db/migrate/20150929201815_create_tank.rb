class CreateTank < ActiveRecord::Migration
  def change
    create_table :tanks, id: false do |t|
      t.integer :tank_id
      t.integer :level
      t.string :name_i18n
    end
    reversible do |change|
      change.up do
        Member.connection.execute("ALTER TABLE tanks ADD PRIMARY KEY (tank_id)")
      end
    end
  end
end
