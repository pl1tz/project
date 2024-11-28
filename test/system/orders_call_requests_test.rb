require "application_system_test_case"

class OrdersCallRequestsTest < ApplicationSystemTestCase
  setup do
    @orders_call_request = orders_call_requests(:one)
  end

  test "visiting the index" do
    visit orders_call_requests_url
    assert_selector "h1", text: "Orders call requests"
  end

  test "should create orders call request" do
    visit orders_call_requests_url
    click_on "New orders call request"

    fill_in "Call request", with: @orders_call_request.call_request_id
    fill_in "Description", with: @orders_call_request.description
    fill_in "Order status", with: @orders_call_request.order_status_id
    click_on "Create Orders call request"

    assert_text "Orders call request was successfully created"
    click_on "Back"
  end

  test "should update Orders call request" do
    visit orders_call_request_url(@orders_call_request)
    click_on "Edit this orders call request", match: :first

    fill_in "Call request", with: @orders_call_request.call_request_id
    fill_in "Description", with: @orders_call_request.description
    fill_in "Order status", with: @orders_call_request.order_status_id
    click_on "Update Orders call request"

    assert_text "Orders call request was successfully updated"
    click_on "Back"
  end

  test "should destroy Orders call request" do
    visit orders_call_request_url(@orders_call_request)
    click_on "Destroy this orders call request", match: :first

    assert_text "Orders call request was successfully destroyed"
  end
end
