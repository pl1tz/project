class CreateEnginePowerTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :engine_power_types do |t|
      t.integer :power

      t.timestamps
    end
  end
end
