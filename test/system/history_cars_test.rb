require "application_system_test_case"

class HistoryCarsTest < ApplicationSystemTestCase
  setup do
    @history_car = history_cars(:one)
  end

  test "visiting the index" do
    visit history_cars_url
    assert_selector "h1", text: "History cars"
  end

  test "should create history car" do
    visit history_cars_url
    click_on "New history car"

    check "Accidents found" if @history_car.accidents_found
    fill_in "Car", with: @history_car.car_id
    check "Carsharing usage" if @history_car.carsharing_usage
    check "Diagnostics found" if @history_car.diagnostics_found
    check "Imported" if @history_car.imported
    check "Insurance found" if @history_car.insurance_found
    fill_in "Last mileage", with: @history_car.last_mileage
    check "Pledge status" if @history_car.pledge_status
    fill_in "Previous owners", with: @history_car.previous_owners
    check "Recall campaigns found" if @history_car.recall_campaigns_found
    fill_in "Registration number", with: @history_car.registration_number
    check "Registration restrictions" if @history_car.registration_restrictions
    check "Repair estimates found" if @history_car.repair_estimates_found
    check "Taxi usage" if @history_car.taxi_usage
    check "Technical inspection found" if @history_car.technical_inspection_found
    fill_in "Vin", with: @history_car.vin
    check "Wanted status" if @history_car.wanted_status
    click_on "Create History car"

    assert_text "History car was successfully created"
    click_on "Back"
  end

  test "should update History car" do
    visit history_car_url(@history_car)
    click_on "Edit this history car", match: :first

    check "Accidents found" if @history_car.accidents_found
    fill_in "Car", with: @history_car.car_id
    check "Carsharing usage" if @history_car.carsharing_usage
    check "Diagnostics found" if @history_car.diagnostics_found
    check "Imported" if @history_car.imported
    check "Insurance found" if @history_car.insurance_found
    fill_in "Last mileage", with: @history_car.last_mileage
    check "Pledge status" if @history_car.pledge_status
    fill_in "Previous owners", with: @history_car.previous_owners
    check "Recall campaigns found" if @history_car.recall_campaigns_found
    fill_in "Registration number", with: @history_car.registration_number
    check "Registration restrictions" if @history_car.registration_restrictions
    check "Repair estimates found" if @history_car.repair_estimates_found
    check "Taxi usage" if @history_car.taxi_usage
    check "Technical inspection found" if @history_car.technical_inspection_found
    fill_in "Vin", with: @history_car.vin
    check "Wanted status" if @history_car.wanted_status
    click_on "Update History car"

    assert_text "History car was successfully updated"
    click_on "Back"
  end

  test "should destroy History car" do
    visit history_car_url(@history_car)
    click_on "Destroy this history car", match: :first

    assert_text "History car was successfully destroyed"
  end
end
