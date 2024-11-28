class Generation < ApplicationRecord
  belongs_to :model
  has_many :cars

  # validates :name, presence: true
  # validates :start_date, presence: true
  # validates :end_date, presence: true
  # validate :end_date_after_start_date

  # private

  # def end_date_after_start_date
  #   return if end_date.blank? || start_date.blank?

  #   if end_date < start_date
  #     errors.add(:end_date, "должна быть позже даты начала")
  #   end
  # end
end
