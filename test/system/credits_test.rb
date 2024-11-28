require "application_system_test_case"

class CreditsTest < ApplicationSystemTestCase
  setup do
    @credit = credits(:one)
  end

  test "visiting the index" do
    visit credits_url
    assert_selector "h1", text: "Credits"
  end

  test "should create credit" do
    visit credits_url
    click_on "New credit"

    fill_in "Banks", with: @credit.banks_id
    fill_in "Car", with: @credit.car_id
    fill_in "Credit term", with: @credit.credit_term
    fill_in "Initial contribution", with: @credit.initial_contribution
    fill_in "Name", with: @credit.name
    fill_in "Phone", with: @credit.phone
    fill_in "Programs", with: @credit.programs_id
    click_on "Create Credit"

    assert_text "Credit was successfully created"
    click_on "Back"
  end

  test "should update Credit" do
    visit credit_url(@credit)
    click_on "Edit this credit", match: :first

    fill_in "Banks", with: @credit.banks_id
    fill_in "Car", with: @credit.car_id
    fill_in "Credit term", with: @credit.credit_term
    fill_in "Initial contribution", with: @credit.initial_contribution
    fill_in "Name", with: @credit.name
    fill_in "Phone", with: @credit.phone
    fill_in "Programs", with: @credit.programs_id
    click_on "Update Credit"

    assert_text "Credit was successfully updated"
    click_on "Back"
  end

  test "should destroy Credit" do
    visit credit_url(@credit)
    click_on "Destroy this credit", match: :first

    assert_text "Credit was successfully destroyed"
  end
end
