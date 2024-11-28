class CreateBanners < ActiveRecord::Migration[7.2]
  def change
    create_table :banners do |t|
      t.string :image
      t.boolean :status
      t.string :main_text
      t.string :second_text
      t.string :main_2_text
      t.string :second_2_text

      t.timestamps
    end
  end
end
