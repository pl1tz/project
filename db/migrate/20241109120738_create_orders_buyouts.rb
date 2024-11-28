class CreateOrdersBuyouts < ActiveRecord::Migration[7.2]
  def change
    create_table :orders_buyouts do |t|
      t.references :buyout, null: false, foreign_key: true
      t.references :order_status, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
