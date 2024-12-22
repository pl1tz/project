require "application_system_test_case"

class CarCatalogExtrasTest < ApplicationSystemTestCase
  setup do
    @car_catalog_extra = car_catalog_extras(:one)
  end

  test "visiting the index" do
    visit car_catalog_extras_url
    assert_selector "h1", text: "Car catalog extras"
  end

  test "should create car catalog extra" do
    visit car_catalog_extras_url
    click_on "New car catalog extra"

    fill_in "Car catalog configuration", with: @car_catalog_extra.car_catalog_configuration_id
    fill_in "Car catalog extra group", with: @car_catalog_extra.car_catalog_extra_group_id
    fill_in "Car catalog extra name", with: @car_catalog_extra.car_catalog_extra_name_id
    click_on "Create Car catalog extra"

    assert_text "Car catalog extra was successfully created"
    click_on "Back"
  end

  test "should update Car catalog extra" do
    visit car_catalog_extra_url(@car_catalog_extra)
    click_on "Edit this car catalog extra", match: :first

    fill_in "Car catalog configuration", with: @car_catalog_extra.car_catalog_configuration_id
    fill_in "Car catalog extra group", with: @car_catalog_extra.car_catalog_extra_group_id
    fill_in "Car catalog extra name", with: @car_catalog_extra.car_catalog_extra_name_id
    click_on "Update Car catalog extra"

    assert_text "Car catalog extra was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog extra" do
    visit car_catalog_extra_url(@car_catalog_extra)
    click_on "Destroy this car catalog extra", match: :first

    assert_text "Car catalog extra was successfully destroyed"
  end
end
