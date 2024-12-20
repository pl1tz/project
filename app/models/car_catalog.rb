class CarCatalog < ApplicationRecord
    has_many :car_colors, dependent: :destroy
    has_many :car_catalog_contents, dependent: :destroy
    has_many :car_catalog_texnos, dependent: :destroy
    has_many :car_catalog_engines, dependent: :destroy
    has_many :car_catalog_images, dependent: :destroy

end
