class CreateProvinces < ActiveRecord::Migration[8.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :gst, precision: 5, scale: 2, default: 0.0
      t.decimal :pst, precision: 5, scale: 2, default: 0.0
      t.decimal :hst, precision: 5, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
