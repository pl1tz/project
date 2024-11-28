class AddComplectationNameToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :complectation_name, :string
  end
end
