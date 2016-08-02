class AddDeletedAtToRecordedResources < ActiveRecord::Migration
  def change
    add_column :recorded_resources, :deleted_at, :datetime
  end
end
