require "application_system_test_case"

class EnginePowerTypesTest < ApplicationSystemTestCase
  setup do
    @engine_power_type = engine_power_types(:one)
  end

  test "visiting the index" do
    visit engine_power_types_url
    assert_selector "h1", text: "Engine power types"
  end

  test "should create engine power type" do
    visit engine_power_types_url
    click_on "New engine power type"

    fill_in "Power", with: @engine_power_type.power
    click_on "Create Engine power type"

    assert_text "Engine power type was successfully created"
    click_on "Back"
  end

  test "should update Engine power type" do
    visit engine_power_type_url(@engine_power_type)
    click_on "Edit this engine power type", match: :first

    fill_in "Power", with: @engine_power_type.power
    click_on "Update Engine power type"

    assert_text "Engine power type was successfully updated"
    click_on "Back"
  end

  test "should destroy Engine power type" do
    visit engine_power_type_url(@engine_power_type)
    click_on "Destroy this engine power type", match: :first

    assert_text "Engine power type was successfully destroyed"
  end
end
