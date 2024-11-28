require "application_system_test_case"

class TradeInOffersTest < ApplicationSystemTestCase
  setup do
    @trade_in_offer = trade_in_offers(:one)
  end

  test "visiting the index" do
    visit trade_in_offers_url
    assert_selector "h1", text: "Trade in offers"
  end

  test "should create trade in offer" do
    visit trade_in_offers_url
    click_on "New trade in offer"

    fill_in "Customer car", with: @trade_in_offer.customer_car
    click_on "Create Trade in offer"

    assert_text "Trade in offer was successfully created"
    click_on "Back"
  end

  test "should update Trade in offer" do
    visit trade_in_offer_url(@trade_in_offer)
    click_on "Edit this trade in offer", match: :first

    fill_in "Customer car", with: @trade_in_offer.customer_car
    click_on "Update Trade in offer"

    assert_text "Trade in offer was successfully updated"
    click_on "Back"
  end

  test "should destroy Trade in offer" do
    visit trade_in_offer_url(@trade_in_offer)
    click_on "Destroy this trade in offer", match: :first

    assert_text "Trade in offer was successfully destroyed"
  end
end
