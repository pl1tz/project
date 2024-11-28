class ChangeCarIdNullInCallRequests < ActiveRecord::Migration[7.2]
  def change
    change_column_null :call_requests, :car_id, true # Установите значение NULL для car_id
  end
end 