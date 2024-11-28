require "application_system_test_case"

class CarBuybacksTest < ApplicationSystemTestCase
  setup do
    @car_buyback = car_buybacks(:one)
  end

  test "visiting the index" do
    visit car_buybacks_url
    assert_selector "h1", text: "Car buybacks"
  end

  test "should create car buyback" do
    visit car_buybacks_url
    click_on "New car buyback"

    fill_in "Buyback price", with: @car_buyback.buyback_price
    fill_in "Car", with: @car_buyback.car_id
    fill_in "Created at", with: @car_buyback.created_at
    click_on "Create Car buyback"

    assert_text "Car buyback was successfully created"
    click_on "Back"
  end

  test "should update Car buyback" do
    visit car_buyback_url(@car_buyback)
    click_on "Edit this car buyback", match: :first

    fill_in "Buyback price", with: @car_buyback.buyback_price
    fill_in "Car", with: @car_buyback.car_id
    fill_in "Created at", with: @car_buyback.created_at.to_s
    click_on "Update Car buyback"

    assert_text "Car buyback was successfully updated"
    click_on "Back"
  end

  test "should destroy Car buyback" do
    visit car_buyback_url(@car_buyback)
    click_on "Destroy this car buyback", match: :first

    assert_text "Car buyback was successfully destroyed"
  end
end
