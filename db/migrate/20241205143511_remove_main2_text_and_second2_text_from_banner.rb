class RemoveMain2TextAndSecond2TextFromBanner < ActiveRecord::Migration[7.2]
  def change
    remove_column :banners, :main_2_text, :string
    remove_column :banners, :second_2_text, :string
  end
end
