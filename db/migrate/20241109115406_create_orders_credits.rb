class CreateOrdersCredits < ActiveRecord::Migration[7.2]
  def change
    create_table :orders_credits do |t|
      t.references :credit, null: false, foreign_key: true
      t.references :order_status, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
