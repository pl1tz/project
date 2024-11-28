class CreateCredits < ActiveRecord::Migration[7.2]
  def change
    create_table :credits do |t|
      t.integer :car_id
      t.string :name
      t.string :phone
      t.integer :credit_term
      t.decimal :initial_contribution
      t.integer :banks_id
      t.integer :programs_id

      t.timestamps
    end
    add_foreign_key :credits, :cars, column: :car_id
    add_foreign_key :credits, :banks, column: :banks_id
    add_foreign_key :credits, :programs, column: :programs_id
  end
end

