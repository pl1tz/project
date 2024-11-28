class AddGenerationToCars < ActiveRecord::Migration[7.2]
  def change
    add_reference :cars, :generation, null: false, foreign_key: true
  end
end
