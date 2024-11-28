class AddExtraNameIdToExtras < ActiveRecord::Migration[7.2]
  def change
    add_reference :extras, :extra_name, foreign_key: true
    remove_column :extras, :name, :string
  end
end
