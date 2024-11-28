class CreateExtras < ActiveRecord::Migration[7.2]
  def change
    create_table :extras do |t|
      t.references :car, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
