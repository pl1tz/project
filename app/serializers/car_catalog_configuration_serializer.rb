class CarCatalogConfigurationSerializer < ActiveModel::Serializer
  attributes :id, :package_group, :package_name, :volume, :transmission, :power, :price, :credit_discount, :trade_in_discount, :recycling_discount, :special_price
  has_one :car_catalog
end
