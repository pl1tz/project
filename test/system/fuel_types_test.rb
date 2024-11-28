require "application_system_test_case"

class FuelTypesTest < ApplicationSystemTestCase
  setup do
    @fuel_type = fuel_types(:one)
  end

  test "visiting the index" do
    visit fuel_types_url
    assert_selector "h1", text: "Fuel types"
  end

  test "should create fuel type" do
    visit fuel_types_url
    click_on "New fuel type"

    fill_in "Name", with: @fuel_type.name
    click_on "Create Fuel type"

    assert_text "Fuel type was successfully created"
    click_on "Back"
  end

  test "should update Fuel type" do
    visit fuel_type_url(@fuel_type)
    click_on "Edit this fuel type", match: :first

    fill_in "Name", with: @fuel_type.name
    click_on "Update Fuel type"

    assert_text "Fuel type was successfully updated"
    click_on "Back"
  end

  test "should destroy Fuel type" do
    visit fuel_type_url(@fuel_type)
    click_on "Destroy this fuel type", match: :first

    assert_text "Fuel type was successfully destroyed"
  end
end
