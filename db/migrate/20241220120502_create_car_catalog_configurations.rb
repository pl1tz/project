class CreateCarCatalogConfigurations < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_configurations do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :package_group
      t.string :package_name
      t.float :volume
      t.float :transmission
      t.integer :power
      t.integer :price
      t.integer :credit_discount
      t.integer :trade_in_discount
      t.integer :recycling_discount
      t.integer :special_price

      t.timestamps
    end
  end
end
