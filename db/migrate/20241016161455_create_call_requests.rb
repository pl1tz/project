class CreateCallRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :call_requests do |t|
      t.bigint :car_id
      t.string :name
      t.string :phone
      t.string :preferred_time

      t.timestamps
    end
    add_foreign_key :call_requests, :cars, column: :car_id
  end
end
