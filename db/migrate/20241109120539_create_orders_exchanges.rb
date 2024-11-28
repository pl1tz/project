class CreateOrdersExchanges < ActiveRecord::Migration[7.2]
  def change
    create_table :orders_exchanges do |t|
      t.references :exchange, null: false, foreign_key: true
      t.references :order_status, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
