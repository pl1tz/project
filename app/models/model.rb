class Model < ApplicationRecord
  belongs_to :brand
  has_many :generations
  has_many :cars
  
end
