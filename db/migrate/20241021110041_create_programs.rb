class CreatePrograms < ActiveRecord::Migration[7.2]
  def change
    create_table :programs do |t|
      t.integer :bank_id
      t.string :program_name
      t.float :interest_rate

      t.timestamps
    end
    add_foreign_key :programs, :banks, column: :bank_id
  end
end
