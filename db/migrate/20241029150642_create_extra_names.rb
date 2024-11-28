class CreateExtraNames < ActiveRecord::Migration[7.2]
  def change
    create_table :extra_names do |t|
      t.string :name

      t.timestamps
    end
    add_index :extra_names, :name, unique: true
  end
end
