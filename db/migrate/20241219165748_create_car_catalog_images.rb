class CreateCarCatalogImages < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_images do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
