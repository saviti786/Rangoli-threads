class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :status, default: 'pending'
      t.decimal :pst_rate, precision: 5, scale: 2, default: 0.0
      t.decimal :gst_rate, precision: 5, scale: 2, default: 0.0
      t.decimal :hst_rate, precision: 5, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
