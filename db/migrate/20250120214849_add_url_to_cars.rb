class AddUrlToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :url, :string
  end
end
