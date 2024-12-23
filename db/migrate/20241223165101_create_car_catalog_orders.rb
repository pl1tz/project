class CreateCarCatalogOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_orders do |t|
      t.references :order_status, null: false, foreign_key: true
      t.bigint :car_catalog
      t.string :name
      t.string :phone

      t.timestamps
    end
    add_foreign_key :car_catalog_orders, :car_catalogs, column: :car_catalog
  end
end
