class CreateCarCatalogEngines < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_engines do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :name_engines
      t.integer :torque
      t.integer :power
      t.integer :cylinders
      t.float :engine_volume
      t.string :fuel_type
      t.string :engine_type

      t.timestamps
    end
  end
end
