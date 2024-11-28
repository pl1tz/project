require "test_helper"

class OrdersCallRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orders_call_request = orders_call_requests(:one)
  end

  test "should get index" do
    get orders_call_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_orders_call_request_url
    assert_response :success
  end

  test "should create orders_call_request" do
    assert_difference("OrdersCallRequest.count") do
      post orders_call_requests_url, params: { orders_call_request: { call_request_id: @orders_call_request.call_request_id, description: @orders_call_request.description, order_status_id: @orders_call_request.order_status_id } }
    end

    assert_redirected_to orders_call_request_url(OrdersCallRequest.last)
  end

  test "should show orders_call_request" do
    get orders_call_request_url(@orders_call_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_orders_call_request_url(@orders_call_request)
    assert_response :success
  end

  test "should update orders_call_request" do
    patch orders_call_request_url(@orders_call_request), params: { orders_call_request: { call_request_id: @orders_call_request.call_request_id, description: @orders_call_request.description, order_status_id: @orders_call_request.order_status_id } }
    assert_redirected_to orders_call_request_url(@orders_call_request)
  end

  test "should destroy orders_call_request" do
    assert_difference("OrdersCallRequest.count", -1) do
      delete orders_call_request_url(@orders_call_request)
    end

    assert_redirected_to orders_call_requests_url
  end
end
