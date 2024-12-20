class CreateCarCatalogTexnos < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_texnos do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :image
      t.integer :width
      t.integer :height
      t.integer :length

      t.timestamps
    end
  end
end
