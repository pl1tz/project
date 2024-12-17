class CreateCarColors < ActiveRecord::Migration[7.2]
  def change
    create_table :car_colors do |t|
      t.references :car_catalog, null: false, foreign_key: true
      t.string :background
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
