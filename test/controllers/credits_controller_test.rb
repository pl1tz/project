require "test_helper"

class CreditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit = credits(:one)
  end

  test "should get index" do
    get credits_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_url
    assert_response :success
  end

  test "should create credit" do
    assert_difference("Credit.count") do
      post credits_url, params: { credit: { banks_id: @credit.banks_id, car_id: @credit.car_id, credit_term: @credit.credit_term, initial_contribution: @credit.initial_contribution, name: @credit.name, phone: @credit.phone, programs_id: @credit.programs_id } }
    end

    assert_redirected_to credit_url(Credit.last)
  end

  test "should show credit" do
    get credit_url(@credit)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_url(@credit)
    assert_response :success
  end

  test "should update credit" do
    patch credit_url(@credit), params: { credit: { banks_id: @credit.banks_id, car_id: @credit.car_id, credit_term: @credit.credit_term, initial_contribution: @credit.initial_contribution, name: @credit.name, phone: @credit.phone, programs_id: @credit.programs_id } }
    assert_redirected_to credit_url(@credit)
  end

  test "should destroy credit" do
    assert_difference("Credit.count", -1) do
      delete credit_url(@credit)
    end

    assert_redirected_to credits_url
  end
end
