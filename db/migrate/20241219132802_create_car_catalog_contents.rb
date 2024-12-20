class CreateCarCatalogContents < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_contents do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
