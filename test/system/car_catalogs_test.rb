require "application_system_test_case"

class CarCatalogsTest < ApplicationSystemTestCase
  setup do
    @car_catalog = car_catalogs(:one)
  end

  test "visiting the index" do
    visit car_catalogs_url
    assert_selector "h1", text: "Car catalogs"
  end

  test "should create car catalog" do
    visit car_catalogs_url
    click_on "New car catalog"

    fill_in "Acceleration", with: @car_catalog.acceleration
    fill_in "Brand", with: @car_catalog.brand
    fill_in "Consumption", with: @car_catalog.consumption
    fill_in "Max speed", with: @car_catalog.max_speed
    fill_in "Model", with: @car_catalog.model
    fill_in "Power", with: @car_catalog.power
    click_on "Create Car catalog"

    assert_text "Car catalog was successfully created"
    click_on "Back"
  end

  test "should update Car catalog" do
    visit car_catalog_url(@car_catalog)
    click_on "Edit this car catalog", match: :first

    fill_in "Acceleration", with: @car_catalog.acceleration
    fill_in "Brand", with: @car_catalog.brand
    fill_in "Consumption", with: @car_catalog.consumption
    fill_in "Max speed", with: @car_catalog.max_speed
    fill_in "Model", with: @car_catalog.model
    fill_in "Power", with: @car_catalog.power
    click_on "Update Car catalog"

    assert_text "Car catalog was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog" do
    visit car_catalog_url(@car_catalog)
    click_on "Destroy this car catalog", match: :first

    assert_text "Car catalog was successfully destroyed"
  end
end
