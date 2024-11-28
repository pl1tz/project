require "application_system_test_case"

class CreditOffersTest < ApplicationSystemTestCase
  setup do
    @credit_offer = credit_offers(:one)
  end

  test "visiting the index" do
    visit credit_offers_url
    assert_selector "h1", text: "Credit offers"
  end

  test "should create credit offer" do
    visit credit_offers_url
    click_on "New credit offer"

    fill_in "Bank", with: @credit_offer.bank_id
    fill_in "Credit programs", with: @credit_offer.credit_programs_id
    click_on "Create Credit offer"

    assert_text "Credit offer was successfully created"
    click_on "Back"
  end

  test "should update Credit offer" do
    visit credit_offer_url(@credit_offer)
    click_on "Edit this credit offer", match: :first

    fill_in "Bank", with: @credit_offer.bank_id
    fill_in "Credit programs", with: @credit_offer.credit_programs_id
    click_on "Update Credit offer"

    assert_text "Credit offer was successfully updated"
    click_on "Back"
  end

  test "should destroy Credit offer" do
    visit credit_offer_url(@credit_offer)
    click_on "Destroy this credit offer", match: :first

    assert_text "Credit offer was successfully destroyed"
  end
end
