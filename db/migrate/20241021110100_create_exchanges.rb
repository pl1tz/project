class CreateExchanges < ActiveRecord::Migration[7.2]
  def change
    create_table :exchanges do |t|
      t.integer :car_id
      t.text :customer_car
      t.string :name
      t.string :phone
      t.integer :credit_term
      t.decimal :initial_contribution

      t.timestamps
    end
    add_foreign_key :exchanges, :cars, column: :car_id
  end
end
