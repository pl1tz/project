require "application_system_test_case"

class CarCatalogConfigurationsTest < ApplicationSystemTestCase
  setup do
    @car_catalog_configuration = car_catalog_configurations(:one)
  end

  test "visiting the index" do
    visit car_catalog_configurations_url
    assert_selector "h1", text: "Car catalog configurations"
  end

  test "should create car catalog configuration" do
    visit car_catalog_configurations_url
    click_on "New car catalog configuration"

    fill_in "Car catalog", with: @car_catalog_configuration.car_catalog_id
    fill_in "Credit discount", with: @car_catalog_configuration.credit_discount
    fill_in "Package group", with: @car_catalog_configuration.package_group
    fill_in "Package name", with: @car_catalog_configuration.package_name
    fill_in "Power", with: @car_catalog_configuration.power
    fill_in "Price", with: @car_catalog_configuration.price
    fill_in "Recycling discount", with: @car_catalog_configuration.recycling_discount
    fill_in "Special price", with: @car_catalog_configuration.special_price
    fill_in "Trade in discount", with: @car_catalog_configuration.trade_in_discount
    fill_in "Transmission", with: @car_catalog_configuration.transmission
    fill_in "Volume", with: @car_catalog_configuration.volume
    click_on "Create Car catalog configuration"

    assert_text "Car catalog configuration was successfully created"
    click_on "Back"
  end

  test "should update Car catalog configuration" do
    visit car_catalog_configuration_url(@car_catalog_configuration)
    click_on "Edit this car catalog configuration", match: :first

    fill_in "Car catalog", with: @car_catalog_configuration.car_catalog_id
    fill_in "Credit discount", with: @car_catalog_configuration.credit_discount
    fill_in "Package group", with: @car_catalog_configuration.package_group
    fill_in "Package name", with: @car_catalog_configuration.package_name
    fill_in "Power", with: @car_catalog_configuration.power
    fill_in "Price", with: @car_catalog_configuration.price
    fill_in "Recycling discount", with: @car_catalog_configuration.recycling_discount
    fill_in "Special price", with: @car_catalog_configuration.special_price
    fill_in "Trade in discount", with: @car_catalog_configuration.trade_in_discount
    fill_in "Transmission", with: @car_catalog_configuration.transmission
    fill_in "Volume", with: @car_catalog_configuration.volume
    click_on "Update Car catalog configuration"

    assert_text "Car catalog configuration was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog configuration" do
    visit car_catalog_configuration_url(@car_catalog_configuration)
    click_on "Destroy this car catalog configuration", match: :first

    assert_text "Car catalog configuration was successfully destroyed"
  end
end
