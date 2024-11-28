require "test_helper"

class CallRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @call_request = call_requests(:one)
  end

  test "should get index" do
    get call_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_call_request_url
    assert_response :success
  end

  test "should create call_request" do
    assert_difference("CallRequest.count") do
      post call_requests_url, params: { call_request: { car_id: @call_request.car_id, name: @call_request.name, phone: @call_request.phone, preferred_time: @call_request.preferred_time } }
    end

    assert_redirected_to call_request_url(CallRequest.last)
  end

  test "should show call_request" do
    get call_request_url(@call_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_call_request_url(@call_request)
    assert_response :success
  end

  test "should update call_request" do
    patch call_request_url(@call_request), params: { call_request: { car_id: @call_request.car_id, name: @call_request.name, phone: @call_request.phone, preferred_time: @call_request.preferred_time } }
    assert_redirected_to call_request_url(@call_request)
  end

  test "should destroy call_request" do
    assert_difference("CallRequest.count", -1) do
      delete call_request_url(@call_request)
    end

    assert_redirected_to call_requests_url
  end
end
