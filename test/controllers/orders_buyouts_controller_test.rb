require "test_helper"

class OrdersBuyoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orders_buyout = orders_buyouts(:one)
  end

  test "should get index" do
    get orders_buyouts_url
    assert_response :success
  end

  test "should get new" do
    get new_orders_buyout_url
    assert_response :success
  end

  test "should create orders_buyout" do
    assert_difference("OrdersBuyout.count") do
      post orders_buyouts_url, params: { orders_buyout: { buyout_id: @orders_buyout.buyout_id, description: @orders_buyout.description, order_status_id: @orders_buyout.order_status_id } }
    end

    assert_redirected_to orders_buyout_url(OrdersBuyout.last)
  end

  test "should show orders_buyout" do
    get orders_buyout_url(@orders_buyout)
    assert_response :success
  end

  test "should get edit" do
    get edit_orders_buyout_url(@orders_buyout)
    assert_response :success
  end

  test "should update orders_buyout" do
    patch orders_buyout_url(@orders_buyout), params: { orders_buyout: { buyout_id: @orders_buyout.buyout_id, description: @orders_buyout.description, order_status_id: @orders_buyout.order_status_id } }
    assert_redirected_to orders_buyout_url(@orders_buyout)
  end

  test "should destroy orders_buyout" do
    assert_difference("OrdersBuyout.count", -1) do
      delete orders_buyout_url(@orders_buyout)
    end

    assert_redirected_to orders_buyouts_url
  end
end
