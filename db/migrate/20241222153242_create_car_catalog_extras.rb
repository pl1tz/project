class CreateCarCatalogExtras < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_extras do |t|
      t.references :car_catalog_configuration, null: false, foreign_key: true
      t.references :car_catalog_extra_group, null: false, foreign_key: true
      t.references :car_catalog_extra_name, null: false, foreign_key: true

      t.timestamps
    end
  end
end
