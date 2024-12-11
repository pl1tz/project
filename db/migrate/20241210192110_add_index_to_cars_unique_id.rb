class AddIndexToCarsUniqueId < ActiveRecord::Migration[7.2]
  def change
    add_index :cars, :unique_id, unique: true
  end
end
