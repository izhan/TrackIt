class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :url
      t.string :api
      t.integer :current_price
      t.string :name
      t.string :thumbnail

      t.timestamps
    end
  end
end
