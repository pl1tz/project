class CarCatalog < ApplicationRecord
    has_many :car_colors, dependent: :destroy
    has_many :car_catalog_contents, dependent: :destroy
    has_many :car_catalog_texnos, dependent: :destroy
    has_many :car_catalog_engines, dependent: :destroy
    has_many :car_catalog_images, dependent: :destroy
    has_many :car_catalog_configurations, dependent: :destroy
    has_many :car_catalog_orders, foreign_key: :car_catalog, dependent: :destroy
  end
  