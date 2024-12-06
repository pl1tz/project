class AddSpecialOfferToCar < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :special_offer, :boolean, default: false
  end
end
