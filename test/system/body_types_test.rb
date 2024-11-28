require "application_system_test_case"

class BodyTypesTest < ApplicationSystemTestCase
  setup do
    @body_type = body_types(:one)
  end

  test "visiting the index" do
    visit body_types_url
    assert_selector "h1", text: "Body types"
  end

  test "should create body type" do
    visit body_types_url
    click_on "New body type"

    fill_in "Name", with: @body_type.name
    click_on "Create Body type"

    assert_text "Body type was successfully created"
    click_on "Back"
  end

  test "should update Body type" do
    visit body_type_url(@body_type)
    click_on "Edit this body type", match: :first

    fill_in "Name", with: @body_type.name
    click_on "Update Body type"

    assert_text "Body type was successfully updated"
    click_on "Back"
  end

  test "should destroy Body type" do
    visit body_type_url(@body_type)
    click_on "Destroy this body type", match: :first

    assert_text "Body type was successfully destroyed"
  end
end
