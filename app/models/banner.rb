class Banner < ApplicationRecord

  scope :active, -> { where(status: true) }
end
