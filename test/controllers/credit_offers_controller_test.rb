require "test_helper"

class CreditOffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit_offer = credit_offers(:one)
  end

  test "should get index" do
    get credit_offers_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_offer_url
    assert_response :success
  end

  test "should create credit_offer" do
    assert_difference("CreditOffer.count") do
      post credit_offers_url, params: { credit_offer: { bank_id: @credit_offer.bank_id, credit_programs_id: @credit_offer.credit_programs_id } }
    end

    assert_redirected_to credit_offer_url(CreditOffer.last)
  end

  test "should show credit_offer" do
    get credit_offer_url(@credit_offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_offer_url(@credit_offer)
    assert_response :success
  end

  test "should update credit_offer" do
    patch credit_offer_url(@credit_offer), params: { credit_offer: { bank_id: @credit_offer.bank_id, credit_programs_id: @credit_offer.credit_programs_id } }
    assert_redirected_to credit_offer_url(@credit_offer)
  end

  test "should destroy credit_offer" do
    assert_difference("CreditOffer.count", -1) do
      delete credit_offer_url(@credit_offer)
    end

    assert_redirected_to credit_offers_url
  end
end
