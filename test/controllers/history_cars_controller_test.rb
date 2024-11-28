require "test_helper"

class HistoryCarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @history_car = history_cars(:one)
  end

  test "should get index" do
    get history_cars_url
    assert_response :success
  end

  test "should get new" do
    get new_history_car_url
    assert_response :success
  end

  test "should create history_car" do
    assert_difference("HistoryCar.count") do
      post history_cars_url, params: { history_car: { accidents_found: @history_car.accidents_found, car_id: @history_car.car_id, carsharing_usage: @history_car.carsharing_usage, diagnostics_found: @history_car.diagnostics_found, imported: @history_car.imported, insurance_found: @history_car.insurance_found, last_mileage: @history_car.last_mileage, pledge_status: @history_car.pledge_status, previous_owners: @history_car.previous_owners, recall_campaigns_found: @history_car.recall_campaigns_found, registration_number: @history_car.registration_number, registration_restrictions: @history_car.registration_restrictions, repair_estimates_found: @history_car.repair_estimates_found, taxi_usage: @history_car.taxi_usage, technical_inspection_found: @history_car.technical_inspection_found, vin: @history_car.vin, wanted_status: @history_car.wanted_status } }
    end

    assert_redirected_to history_car_url(HistoryCar.last)
  end

  test "should show history_car" do
    get history_car_url(@history_car)
    assert_response :success
  end

  test "should get edit" do
    get edit_history_car_url(@history_car)
    assert_response :success
  end

  test "should update history_car" do
    patch history_car_url(@history_car), params: { history_car: { accidents_found: @history_car.accidents_found, car_id: @history_car.car_id, carsharing_usage: @history_car.carsharing_usage, diagnostics_found: @history_car.diagnostics_found, imported: @history_car.imported, insurance_found: @history_car.insurance_found, last_mileage: @history_car.last_mileage, pledge_status: @history_car.pledge_status, previous_owners: @history_car.previous_owners, recall_campaigns_found: @history_car.recall_campaigns_found, registration_number: @history_car.registration_number, registration_restrictions: @history_car.registration_restrictions, repair_estimates_found: @history_car.repair_estimates_found, taxi_usage: @history_car.taxi_usage, technical_inspection_found: @history_car.technical_inspection_found, vin: @history_car.vin, wanted_status: @history_car.wanted_status } }
    assert_redirected_to history_car_url(@history_car)
  end

  test "should destroy history_car" do
    assert_difference("HistoryCar.count", -1) do
      delete history_car_url(@history_car)
    end

    assert_redirected_to history_cars_url
  end
end
