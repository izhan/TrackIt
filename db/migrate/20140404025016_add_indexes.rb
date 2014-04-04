class AddIndexes < ActiveRecord::Migration

  def self.up
    add_index :trackers, :user_id
    add_index :trackers, :product_id
  end

  def self.down
    remove_index :trackers, :user_id
    remove_index :trackers, :product_id
  end

end