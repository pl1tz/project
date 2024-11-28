class DropEngineTypes < ActiveRecord::Migration[7.2]
  def change
    remove_reference :cars, :engine_type, foreign_key: true
  end

  def up
    drop_table :engine_types if ActiveRecord::Base.connection.table_exists?(:engine_types)
  end

  def down
    create_table :engine_types do |t|
      t.string :name
      t.integer :engine_power
      t.decimal :engine_capacity

      t.timestamps
    end
  end
end