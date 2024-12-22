class CreateCarCatalogExtraNames < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalog_extra_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
