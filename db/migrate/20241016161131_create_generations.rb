class CreateGenerations < ActiveRecord::Migration[7.2]
  def change
    create_table :generations do |t|
      t.references :model, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
