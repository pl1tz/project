class CallRequest < ApplicationRecord
  belongs_to :car, optional: true
  has_many :orders_call_requests
end

