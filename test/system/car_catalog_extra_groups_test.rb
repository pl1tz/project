require "application_system_test_case"

class CarCatalogExtraGroupsTest < ApplicationSystemTestCase
  setup do
    @car_catalog_extra_group = car_catalog_extra_groups(:one)
  end

  test "visiting the index" do
    visit car_catalog_extra_groups_url
    assert_selector "h1", text: "Car catalog extra groups"
  end

  test "should create car catalog extra group" do
    visit car_catalog_extra_groups_url
    click_on "New car catalog extra group"

    fill_in "Name", with: @car_catalog_extra_group.name
    click_on "Create Car catalog extra group"

    assert_text "Car catalog extra group was successfully created"
    click_on "Back"
  end

  test "should update Car catalog extra group" do
    visit car_catalog_extra_group_url(@car_catalog_extra_group)
    click_on "Edit this car catalog extra group", match: :first

    fill_in "Name", with: @car_catalog_extra_group.name
    click_on "Update Car catalog extra group"

    assert_text "Car catalog extra group was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog extra group" do
    visit car_catalog_extra_group_url(@car_catalog_extra_group)
    click_on "Destroy this car catalog extra group", match: :first

    assert_text "Car catalog extra group was successfully destroyed"
  end
end
