class CreateEngineTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :engine_types do |t|
      t.string :name
      t.integer :engine_power
      t.decimal :engine_capacity

      t.timestamps
    end
  end
end
