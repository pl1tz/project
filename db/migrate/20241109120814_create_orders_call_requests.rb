class CreateOrdersCallRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :orders_call_requests do |t|
      t.references :call_request, null: false, foreign_key: true
      t.references :order_status, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
