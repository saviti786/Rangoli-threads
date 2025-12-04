class AddUniqueIndexToProvincesName < ActiveRecord::Migration[8.0]
  def change
    add_index :provinces, :name, unique: true
  end
end
