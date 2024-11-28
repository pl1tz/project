class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.references :model, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.integer :year
      t.decimal :price
      t.text :description
      t.string :unique_id
      t.references :color, null: false, foreign_key: true
      t.references :body_type, null: false, foreign_key: true
      t.references :engine_type, null: false, foreign_key: true
      t.references :gearbox_type, null: false, foreign_key: true
      t.references :drive_type, null: false, foreign_key: true
      t.references :engine_name_type, null: false, foreign_key: true
      t.references :engine_power_type, null: false, foreign_key: true
      t.references :engine_capacity_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
