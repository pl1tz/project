class CreateModels < ActiveRecord::Migration[7.2]
  def change
    create_table :models do |t|
      t.references :brand, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
