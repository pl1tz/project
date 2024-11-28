class AddOnlineViewAvailableToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :online_view_available, :boolean, default: true
  end
end
