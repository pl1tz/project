require "test_helper"

class PartnerBanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_bank = partner_banks(:one)
  end

  test "should get index" do
    get partner_banks_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_bank_url
    assert_response :success
  end

  test "should create partner_bank" do
    assert_difference("PartnerBank.count") do
      post partner_banks_url, params: { partner_bank: { country: @partner_bank.country, created_at: @partner_bank.created_at, name: @partner_bank.name } }
    end

    assert_redirected_to partner_bank_url(PartnerBank.last)
  end

  test "should show partner_bank" do
    get partner_bank_url(@partner_bank)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_bank_url(@partner_bank)
    assert_response :success
  end

  test "should update partner_bank" do
    patch partner_bank_url(@partner_bank), params: { partner_bank: { country: @partner_bank.country, created_at: @partner_bank.created_at, name: @partner_bank.name } }
    assert_redirected_to partner_bank_url(@partner_bank)
  end

  test "should destroy partner_bank" do
    assert_difference("PartnerBank.count", -1) do
      delete partner_bank_url(@partner_bank)
    end

    assert_redirected_to partner_banks_url
  end
end
