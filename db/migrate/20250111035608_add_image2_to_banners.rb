class AddImage2ToBanners < ActiveRecord::Migration[7.2]
  def change
    add_column :banners, :image2, :string
  end
end
