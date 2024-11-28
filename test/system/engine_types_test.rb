require "application_system_test_case"

class EngineTypesTest < ApplicationSystemTestCase
  setup do
    @engine_type = engine_types(:one)
  end

  test "visiting the index" do
    visit engine_types_url
    assert_selector "h1", text: "Engine types"
  end

  test "should create engine type" do
    visit engine_types_url
    click_on "New engine type"

    fill_in "Engine capacity", with: @engine_type.engine_capacity
    fill_in "Engine power", with: @engine_type.engine_power
    fill_in "Name", with: @engine_type.name
    click_on "Create Engine type"

    assert_text "Engine type was successfully created"
    click_on "Back"
  end

  test "should update Engine type" do
    visit engine_type_url(@engine_type)
    click_on "Edit this engine type", match: :first

    fill_in "Engine capacity", with: @engine_type.engine_capacity
    fill_in "Engine power", with: @engine_type.engine_power
    fill_in "Name", with: @engine_type.name
    click_on "Update Engine type"

    assert_text "Engine type was successfully updated"
    click_on "Back"
  end

  test "should destroy Engine type" do
    visit engine_type_url(@engine_type)
    click_on "Destroy this engine type", match: :first

    assert_text "Engine type was successfully destroyed"
  end
end
