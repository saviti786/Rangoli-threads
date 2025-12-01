class AddFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :on_sale, :boolean, default: false
    add_column :products, :new_arrival, :boolean, default: false
  end
end
