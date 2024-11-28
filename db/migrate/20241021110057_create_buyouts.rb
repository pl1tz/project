class CreateBuyouts < ActiveRecord::Migration[7.2]
  def change
    create_table :buyouts do |t|
      t.string :name
      t.string :phone
      t.text :brand
      t.text :model
      t.integer :year
      t.integer :mileage

      t.timestamps
    end
  end
end
