class AddCarCatalogIdToCarCatalogOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :car_catalog_orders, :car_catalog_id, :bigint, null: true
    add_index :car_catalog_orders, :car_catalog_id
  end
end
