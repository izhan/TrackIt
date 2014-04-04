class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.integer :user_id
      t.integer :original_price
      t.integer :alert_price
      t.integer :product_id
      t.string :name

      t.timestamps
    end
  end
end
