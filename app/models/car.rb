class Car < ApplicationRecord
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
  
  has_many :call_requests
  has_many :images, dependent: :destroy
  has_many :history_cars, dependent: :destroy

  has_many :extras, dependent: :destroy
  has_many :categories, through: :extras

  has_one :history_car

  scope :by_brand_name, -> (brand_name) { joins(model: :brand ).where(brands: { name: brand_name }) if brand_name.present? }
  scope :by_model_name, -> (model_name) { joins(:model).where(models: { name: model_name }) if model_name.present? }
  scope :by_generation, -> (generation_name) { joins(:generation).where(generations: { name: generation_name }) if generation_name.present? }

  scope :by_year_from, -> (year) { where('year >= ?', year) if year.present? }
  scope :by_price, -> (max_price) { where('price <= ?', max_price) if max_price.present? }
  
  scope :by_gearbox_type, -> (gearbox_type_name) { 
    joins(:gearbox_type).where(gearbox_types: { name: gearbox_type_name }) if gearbox_type_name.present? 
  }
  scope :by_body_type, -> (body_type_name) { 
    joins(:body_type).where(body_types: { name: body_type_name }) if body_type_name.present? 
  }
  scope :by_drive_type, -> (drive_type_name) { 
    joins(:drive_type).where(drive_types: { name: drive_type_name }) if drive_type_name.present? 
  }
  scope :by_owners_count, -> (owners_count) { 
    joins(:history_cars).where(history_cars: { previous_owners: owners_count }) if owners_count.present? 
  }
  scope :by_engine_name_type, -> (engine_name_type_name) { 
    joins(:engine_name_type).where(engine_name_types: { name: engine_name_type_name }) if engine_name_type_name.present?
  }
  
end
