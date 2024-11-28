require "application_system_test_case"

class ExtraNamesTest < ApplicationSystemTestCase
  setup do
    @extra_name = extra_names(:one)
  end

  test "visiting the index" do
    visit extra_names_url
    assert_selector "h1", text: "Extra names"
  end

  test "should create extra name" do
    visit extra_names_url
    click_on "New extra name"

    fill_in "Name", with: @extra_name.name
    click_on "Create Extra name"

    assert_text "Extra name was successfully created"
    click_on "Back"
  end

  test "should update Extra name" do
    visit extra_name_url(@extra_name)
    click_on "Edit this extra name", match: :first

    fill_in "Name", with: @extra_name.name
    click_on "Update Extra name"

    assert_text "Extra name was successfully updated"
    click_on "Back"
  end

  test "should destroy Extra name" do
    visit extra_name_url(@extra_name)
    click_on "Destroy this extra name", match: :first

    assert_text "Extra name was successfully destroyed"
  end
end
