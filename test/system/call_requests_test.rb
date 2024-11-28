require "application_system_test_case"

class CallRequestsTest < ApplicationSystemTestCase
  setup do
    @call_request = call_requests(:one)
  end

  test "visiting the index" do
    visit call_requests_url
    assert_selector "h1", text: "Call requests"
  end

  test "should create call request" do
    visit call_requests_url
    click_on "New call request"

    fill_in "Car", with: @call_request.car_id
    fill_in "Name", with: @call_request.name
    fill_in "Phone", with: @call_request.phone
    fill_in "Preferred time", with: @call_request.preferred_time
    click_on "Create Call request"

    assert_text "Call request was successfully created"
    click_on "Back"
  end

  test "should update Call request" do
    visit call_request_url(@call_request)
    click_on "Edit this call request", match: :first

    fill_in "Car", with: @call_request.car_id
    fill_in "Name", with: @call_request.name
    fill_in "Phone", with: @call_request.phone
    fill_in "Preferred time", with: @call_request.preferred_time.to_s
    click_on "Update Call request"

    assert_text "Call request was successfully updated"
    click_on "Back"
  end

  test "should destroy Call request" do
    visit call_request_url(@call_request)
    click_on "Destroy this call request", match: :first

    assert_text "Call request was successfully destroyed"
  end
end
