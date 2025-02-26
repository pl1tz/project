class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
