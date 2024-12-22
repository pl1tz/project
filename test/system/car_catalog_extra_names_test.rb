require "application_system_test_case"

class CarCatalogExtraNamesTest < ApplicationSystemTestCase
  setup do
    @car_catalog_extra_name = car_catalog_extra_names(:one)
  end

  test "visiting the index" do
    visit car_catalog_extra_names_url
    assert_selector "h1", text: "Car catalog extra names"
  end

  test "should create car catalog extra name" do
    visit car_catalog_extra_names_url
    click_on "New car catalog extra name"

    fill_in "Name", with: @car_catalog_extra_name.name
    click_on "Create Car catalog extra name"

    assert_text "Car catalog extra name was successfully created"
    click_on "Back"
  end

  test "should update Car catalog extra name" do
    visit car_catalog_extra_name_url(@car_catalog_extra_name)
    click_on "Edit this car catalog extra name", match: :first

    fill_in "Name", with: @car_catalog_extra_name.name
    click_on "Update Car catalog extra name"

    assert_text "Car catalog extra name was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog extra name" do
    visit car_catalog_extra_name_url(@car_catalog_extra_name)
    click_on "Destroy this car catalog extra name", match: :first

    assert_text "Car catalog extra name was successfully destroyed"
  end
end
