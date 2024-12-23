class CreateCarCatalogOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_orders do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
