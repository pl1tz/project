class Banner < ApplicationRecord
  has_many_attached :images

  scope :active, -> { where(status: true) }
end
