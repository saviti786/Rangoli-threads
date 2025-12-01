class AddDefaultsToProductFlags < ActiveRecord::Migration[8.0]
  def change
    change_column_default :products, :on_sale, from: nil, to: false
    change_column_default :products, :new_arrival, from: nil, to: false
  end
end
