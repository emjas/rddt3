class CreateRecordedResources < ActiveRecord::Migration
  def change
    create_table :recorded_resources, id: false do |t|
      t.integer :player_id, default: nil
      t.datetime :created_at, default: nil
      t.integer :count
      t.float :slope_prev
    end
    reversible do |change|
      change.up do
        RecordedResource.connection.execute("ALTER TABLE recorded_resources ADD PRIMARY KEY (player_id, created_at)")
      end
    end
  end
end
