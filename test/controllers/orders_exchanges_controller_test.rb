require "test_helper"

class OrdersExchangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orders_exchange = orders_exchanges(:one)
  end

  test "should get index" do
    get orders_exchanges_url
    assert_response :success
  end

  test "should get new" do
    get new_orders_exchange_url
    assert_response :success
  end

  test "should create orders_exchange" do
    assert_difference("OrdersExchange.count") do
      post orders_exchanges_url, params: { orders_exchange: { description: @orders_exchange.description, exchanges_id: @orders_exchange.exchanges_id, order_status_id: @orders_exchange.order_status_id } }
    end

    assert_redirected_to orders_exchange_url(OrdersExchange.last)
  end

  test "should show orders_exchange" do
    get orders_exchange_url(@orders_exchange)
    assert_response :success
  end

  test "should get edit" do
    get edit_orders_exchange_url(@orders_exchange)
    assert_response :success
  end

  test "should update orders_exchange" do
    patch orders_exchange_url(@orders_exchange), params: { orders_exchange: { description: @orders_exchange.description, exchanges_id: @orders_exchange.exchanges_id, order_status_id: @orders_exchange.order_status_id } }
    assert_redirected_to orders_exchange_url(@orders_exchange)
  end

  test "should destroy orders_exchange" do
    assert_difference("OrdersExchange.count", -1) do
      delete orders_exchange_url(@orders_exchange)
    end

    assert_redirected_to orders_exchanges_url
  end
end
