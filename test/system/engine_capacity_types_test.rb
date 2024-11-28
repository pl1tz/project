require "application_system_test_case"

class EngineCapacityTypesTest < ApplicationSystemTestCase
  setup do
    @engine_capacity_type = engine_capacity_types(:one)
  end

  test "visiting the index" do
    visit engine_capacity_types_url
    assert_selector "h1", text: "Engine capacity types"
  end

  test "should create engine capacity type" do
    visit engine_capacity_types_url
    click_on "New engine capacity type"

    fill_in "Capacity", with: @engine_capacity_type.capacity
    click_on "Create Engine capacity type"

    assert_text "Engine capacity type was successfully created"
    click_on "Back"
  end

  test "should update Engine capacity type" do
    visit engine_capacity_type_url(@engine_capacity_type)
    click_on "Edit this engine capacity type", match: :first

    fill_in "Capacity", with: @engine_capacity_type.capacity
    click_on "Update Engine capacity type"

    assert_text "Engine capacity type was successfully updated"
    click_on "Back"
  end

  test "should destroy Engine capacity type" do
    visit engine_capacity_type_url(@engine_capacity_type)
    click_on "Destroy this engine capacity type", match: :first

    assert_text "Engine capacity type was successfully destroyed"
  end
end
