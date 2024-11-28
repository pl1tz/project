require "test_helper"

class TradeInOffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_in_offer = trade_in_offers(:one)
  end

  test "should get index" do
    get trade_in_offers_url
    assert_response :success
  end

  test "should get new" do
    get new_trade_in_offer_url
    assert_response :success
  end

  test "should create trade_in_offer" do
    assert_difference("TradeInOffer.count") do
      post trade_in_offers_url, params: { trade_in_offer: { customer_car: @trade_in_offer.customer_car } }
    end

    assert_redirected_to trade_in_offer_url(TradeInOffer.last)
  end

  test "should show trade_in_offer" do
    get trade_in_offer_url(@trade_in_offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_trade_in_offer_url(@trade_in_offer)
    assert_response :success
  end

  test "should update trade_in_offer" do
    patch trade_in_offer_url(@trade_in_offer), params: { trade_in_offer: { customer_car: @trade_in_offer.customer_car } }
    assert_redirected_to trade_in_offer_url(@trade_in_offer)
  end

  test "should destroy trade_in_offer" do
    assert_difference("TradeInOffer.count", -1) do
      delete trade_in_offer_url(@trade_in_offer)
    end

    assert_redirected_to trade_in_offers_url
  end
end
