require "application_system_test_case"

class CarCatalogEnginesTest < ApplicationSystemTestCase
  setup do
    @car_catalog_engine = car_catalog_engines(:one)
  end

  test "visiting the index" do
    visit car_catalog_engines_url
    assert_selector "h1", text: "Car catalog engines"
  end

  test "should create car catalog engine" do
    visit car_catalog_engines_url
    click_on "New car catalog engine"

    fill_in "Car catalog", with: @car_catalog_engine.car_catalog_id
    fill_in "Cylinders", with: @car_catalog_engine.cylinders
    fill_in "Engine type", with: @car_catalog_engine.engine_type
    fill_in "Engine volume", with: @car_catalog_engine.engine_volume
    fill_in "Fuel type", with: @car_catalog_engine.fuel_type
    fill_in "Power", with: @car_catalog_engine.power
    fill_in "Torque", with: @car_catalog_engine.torque
    click_on "Create Car catalog engine"

    assert_text "Car catalog engine was successfully created"
    click_on "Back"
  end

  test "should update Car catalog engine" do
    visit car_catalog_engine_url(@car_catalog_engine)
    click_on "Edit this car catalog engine", match: :first

    fill_in "Car catalog", with: @car_catalog_engine.car_catalog_id
    fill_in "Cylinders", with: @car_catalog_engine.cylinders
    fill_in "Engine type", with: @car_catalog_engine.engine_type
    fill_in "Engine volume", with: @car_catalog_engine.engine_volume
    fill_in "Fuel type", with: @car_catalog_engine.fuel_type
    fill_in "Power", with: @car_catalog_engine.power
    fill_in "Torque", with: @car_catalog_engine.torque
    click_on "Update Car catalog engine"

    assert_text "Car catalog engine was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog engine" do
    visit car_catalog_engine_url(@car_catalog_engine)
    click_on "Destroy this car catalog engine", match: :first

    assert_text "Car catalog engine was successfully destroyed"
  end
end
