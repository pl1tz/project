require "application_system_test_case"

class DriveTypesTest < ApplicationSystemTestCase
  setup do
    @drive_type = drive_types(:one)
  end

  test "visiting the index" do
    visit drive_types_url
    assert_selector "h1", text: "Drive types"
  end

  test "should create drive type" do
    visit drive_types_url
    click_on "New drive type"

    fill_in "Name", with: @drive_type.name
    click_on "Create Drive type"

    assert_text "Drive type was successfully created"
    click_on "Back"
  end

  test "should update Drive type" do
    visit drive_type_url(@drive_type)
    click_on "Edit this drive type", match: :first

    fill_in "Name", with: @drive_type.name
    click_on "Update Drive type"

    assert_text "Drive type was successfully updated"
    click_on "Back"
  end

  test "should destroy Drive type" do
    visit drive_type_url(@drive_type)
    click_on "Destroy this drive type", match: :first

    assert_text "Drive type was successfully destroyed"
  end
end
