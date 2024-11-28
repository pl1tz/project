require "test_helper"

class OrdersCreditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orders_credit = orders_credits(:one)
  end

  test "should get index" do
    get orders_credits_url
    assert_response :success
  end

  test "should get new" do
    get new_orders_credit_url
    assert_response :success
  end

  test "should create orders_credit" do
    assert_difference("OrdersCredit.count") do
      post orders_credits_url, params: { orders_credit: { credit_id: @orders_credit.credit_id, description: @orders_credit.description, order_status_id: @orders_credit.order_status_id } }
    end

    assert_redirected_to orders_credit_url(OrdersCredit.last)
  end

  test "should show orders_credit" do
    get orders_credit_url(@orders_credit)
    assert_response :success
  end

  test "should get edit" do
    get edit_orders_credit_url(@orders_credit)
    assert_response :success
  end

  test "should update orders_credit" do
    patch orders_credit_url(@orders_credit), params: { orders_credit: { credit_id: @orders_credit.credit_id, description: @orders_credit.description, order_status_id: @orders_credit.order_status_id } }
    assert_redirected_to orders_credit_url(@orders_credit)
  end

  test "should destroy orders_credit" do
    assert_difference("OrdersCredit.count", -1) do
      delete orders_credit_url(@orders_credit)
    end

    assert_redirected_to orders_credits_url
  end
end
