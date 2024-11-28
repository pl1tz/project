class CarSerializer < ActiveModel::Serializer
  attributes :id, :year, :price, :description, :online_view_available, :complectation_name, :unique_id

  belongs_to :brand
  belongs_to :model
  belongs_to :generation
  belongs_to :color
  belongs_to :body_type
  belongs_to :engine_name_type
  belongs_to :engine_power_type
  belongs_to :engine_capacity_type
  belongs_to :gearbox_type
  belongs_to :drive_type
  has_many :extras
  has_many :history_cars
  has_many :images

  def extras
    object.extras.includes(:category, :extra_name).group_by { |extra| extra.category.name }.map do |category_name, extras|
      {
        category: category_name,
        names: extras.map { |extra| extra.extra_name.name }
      }
    end
  end

  def images
    object.images.order(id: :asc) # Замените :size на нужное поле для сортировки
  end
end
