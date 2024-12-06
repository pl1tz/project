class BannerSerializer < ActiveModel::Serializer
  attributes :id, :image, :status, :main_text, :second_text
end
