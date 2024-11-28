require "application_system_test_case"

class EngineNameTypesTest < ApplicationSystemTestCase
  setup do
    @engine_name_type = engine_name_types(:one)
  end

  test "visiting the index" do
    visit engine_name_types_url
    assert_selector "h1", text: "Engine name types"
  end

  test "should create engine name type" do
    visit engine_name_types_url
    click_on "New engine name type"

    fill_in "Name", with: @engine_name_type.name
    click_on "Create Engine name type"

    assert_text "Engine name type was successfully created"
    click_on "Back"
  end

  test "should update Engine name type" do
    visit engine_name_type_url(@engine_name_type)
    click_on "Edit this engine name type", match: :first

    fill_in "Name", with: @engine_name_type.name
    click_on "Update Engine name type"

    assert_text "Engine name type was successfully updated"
    click_on "Back"
  end

  test "should destroy Engine name type" do
    visit engine_name_type_url(@engine_name_type)
    click_on "Destroy this engine name type", match: :first

    assert_text "Engine name type was successfully destroyed"
  end
end
