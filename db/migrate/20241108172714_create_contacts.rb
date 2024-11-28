class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.bigint :phone
      t.string :mode_operation
      t.string :auto_address

      t.timestamps
    end
  end
end
