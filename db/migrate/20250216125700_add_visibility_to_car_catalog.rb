class AddVisibilityToCarCatalog < ActiveRecord::Migration[7.2]
  def change
    add_column :car_catalogs, :visibility, :boolean, default: true, null: false
  end
end
