class AddUserOrderNumberToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :user_order_number, :integer
  end
end
