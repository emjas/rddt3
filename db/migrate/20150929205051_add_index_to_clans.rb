class AddIndexToClans < ActiveRecord::Migration
  def change
    add_index :clans, :abbreviation
  end
end
