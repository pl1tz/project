class CarDetailSerializer < ActiveModel::Serializer
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
    has_many :images
    belongs_to :history_cars, serializer: HistoryCarDetailSerializer
  
    def images
      object.images.order(id: :asc).limit(4) # Замените :size на нужное поле для сортировки
    end
  end
  