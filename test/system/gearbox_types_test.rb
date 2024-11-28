require "application_system_test_case"

class GearboxTypesTest < ApplicationSystemTestCase
  setup do
    @gearbox_type = gearbox_types(:one)
  end

  test "visiting the index" do
    visit gearbox_types_url
    assert_selector "h1", text: "Gearbox types"
  end

  test "should create gearbox type" do
    visit gearbox_types_url
    click_on "New gearbox type"

    fill_in "Name", with: @gearbox_type.name
    click_on "Create Gearbox type"

    assert_text "Gearbox type was successfully created"
    click_on "Back"
  end

  test "should update Gearbox type" do
    visit gearbox_type_url(@gearbox_type)
    click_on "Edit this gearbox type", match: :first

    fill_in "Name", with: @gearbox_type.name
    click_on "Update Gearbox type"

    assert_text "Gearbox type was successfully updated"
    click_on "Back"
  end

  test "should destroy Gearbox type" do
    visit gearbox_type_url(@gearbox_type)
    click_on "Destroy this gearbox type", match: :first

    assert_text "Gearbox type was successfully destroyed"
  end
end
