class AddXPathToProducts < ActiveRecord::Migration
  def change
    add_column :products, :xpath, :string
  end
end
