class CreateCarCatalogs < ActiveRecord::Migration[7.2]
  def change
    create_table :car_catalogs do |t|
      t.string :brand
      t.string :model
      t.integer :power
      t.float :acceleration
      t.float :consumption
      t.integer :max_speed

      t.timestamps
    end
  end
end
