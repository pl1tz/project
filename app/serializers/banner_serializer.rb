class BannerSerializer < ActiveModel::Serializer
  attributes :id, :image, :image2, :status, :main_text, :second_text
end
