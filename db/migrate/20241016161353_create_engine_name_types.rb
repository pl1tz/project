class CreateEngineNameTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :engine_name_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
