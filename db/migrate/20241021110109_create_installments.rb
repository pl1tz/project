class CreateInstallments < ActiveRecord::Migration[7.2]
  def change
    create_table :installments do |t|
      t.integer :car_id
      t.string :name
      t.string :phone
      t.integer :credit_term
      t.decimal :initial_contribution

      t.timestamps
    end
    add_foreign_key :installments, :cars, column: :car_id
  end
end
