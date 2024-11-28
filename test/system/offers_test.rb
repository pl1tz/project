require "application_system_test_case"

class OffersTest < ApplicationSystemTestCase
  setup do
    @offer = offers(:one)
  end

  test "visiting the index" do
    visit offers_url
    assert_selector "h1", text: "Offers"
  end

  test "should create offer" do
    visit offers_url
    click_on "New offer"

    fill_in "Car", with: @offer.car_id
    fill_in "Created at", with: @offer.created_at
    fill_in "Credit term", with: @offer.credit_term
    fill_in "Initial contribution", with: @offer.initial_contribution
    fill_in "User name", with: @offer.user_name
    fill_in "User phone", with: @offer.user_phone
    click_on "Create Offer"

    assert_text "Offer was successfully created"
    click_on "Back"
  end

  test "should update Offer" do
    visit offer_url(@offer)
    click_on "Edit this offer", match: :first

    fill_in "Car", with: @offer.car_id
    fill_in "Created at", with: @offer.created_at.to_s
    fill_in "Credit term", with: @offer.credit_term
    fill_in "Initial contribution", with: @offer.initial_contribution
    fill_in "User name", with: @offer.user_name
    fill_in "User phone", with: @offer.user_phone
    click_on "Update Offer"

    assert_text "Offer was successfully updated"
    click_on "Back"
  end

  test "should destroy Offer" do
    visit offer_url(@offer)
    click_on "Destroy this offer", match: :first

    assert_text "Offer was successfully destroyed"
  end
end
