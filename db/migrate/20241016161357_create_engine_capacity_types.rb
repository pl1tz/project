class CreateEngineCapacityTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :engine_capacity_types do |t|
      t.float :capacity

      t.timestamps
    end
  end
end
