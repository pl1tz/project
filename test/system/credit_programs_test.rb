require "application_system_test_case"

class CreditProgramsTest < ApplicationSystemTestCase
  setup do
    @credit_program = credit_programs(:one)
  end

  test "visiting the index" do
    visit credit_programs_url
    assert_selector "h1", text: "Credit programs"
  end

  test "should create credit program" do
    visit credit_programs_url
    click_on "New credit program"

    fill_in "Bank", with: @credit_program.bank_id
    fill_in "Created at", with: @credit_program.created_at
    fill_in "Interest rate", with: @credit_program.interest_rate
    fill_in "Max amount", with: @credit_program.max_amount
    fill_in "Max term", with: @credit_program.max_term
    fill_in "Program name", with: @credit_program.program_name
    click_on "Create Credit program"

    assert_text "Credit program was successfully created"
    click_on "Back"
  end

  test "should update Credit program" do
    visit credit_program_url(@credit_program)
    click_on "Edit this credit program", match: :first

    fill_in "Bank", with: @credit_program.bank_id
    fill_in "Created at", with: @credit_program.created_at.to_s
    fill_in "Interest rate", with: @credit_program.interest_rate
    fill_in "Max amount", with: @credit_program.max_amount
    fill_in "Max term", with: @credit_program.max_term
    fill_in "Program name", with: @credit_program.program_name
    click_on "Update Credit program"

    assert_text "Credit program was successfully updated"
    click_on "Back"
  end

  test "should destroy Credit program" do
    visit credit_program_url(@credit_program)
    click_on "Destroy this credit program", match: :first

    assert_text "Credit program was successfully destroyed"
  end
end
