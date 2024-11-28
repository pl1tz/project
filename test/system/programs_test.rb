require "application_system_test_case"

class ProgramsTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
  end

  test "visiting the index" do
    visit programs_url
    assert_selector "h1", text: "Programs"
  end

  test "should create program" do
    visit programs_url
    click_on "New program"

    fill_in "Bank", with: @program.bank_id
    fill_in "Created at", with: @program.created_at
    fill_in "Interest rate", with: @program.interest_rate
    fill_in "Max amount", with: @program.max_amount
    fill_in "Max term", with: @program.max_term
    fill_in "Program name", with: @program.program_name
    click_on "Create Program"

    assert_text "Program was successfully created"
    click_on "Back"
  end

  test "should update Program" do
    visit program_url(@program)
    click_on "Edit this program", match: :first

    fill_in "Bank", with: @program.bank_id
    fill_in "Created at", with: @program.created_at.to_s
    fill_in "Interest rate", with: @program.interest_rate
    fill_in "Max amount", with: @program.max_amount
    fill_in "Max term", with: @program.max_term
    fill_in "Program name", with: @program.program_name
    click_on "Update Program"

    assert_text "Program was successfully updated"
    click_on "Back"
  end

  test "should destroy Program" do
    visit program_url(@program)
    click_on "Destroy this program", match: :first

    assert_text "Program was successfully destroyed"
  end
end
