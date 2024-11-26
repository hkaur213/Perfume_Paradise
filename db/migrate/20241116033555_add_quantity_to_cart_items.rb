class AddQuantityToCartItems < ActiveRecord::Migration[7.2]
  def change
    add_column :cart_items, :quantity, :integer, default: 1, null: false
  end
end
