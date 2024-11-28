require "application_system_test_case"

class OrdersBuyoutsTest < ApplicationSystemTestCase
  setup do
    @orders_buyout = orders_buyouts(:one)
  end

  test "visiting the index" do
    visit orders_buyouts_url
    assert_selector "h1", text: "Orders buyouts"
  end

  test "should create orders buyout" do
    visit orders_buyouts_url
    click_on "New orders buyout"

    fill_in "Buyout", with: @orders_buyout.buyout_id
    fill_in "Description", with: @orders_buyout.description
    fill_in "Order status", with: @orders_buyout.order_status_id
    click_on "Create Orders buyout"

    assert_text "Orders buyout was successfully created"
    click_on "Back"
  end

  test "should update Orders buyout" do
    visit orders_buyout_url(@orders_buyout)
    click_on "Edit this orders buyout", match: :first

    fill_in "Buyout", with: @orders_buyout.buyout_id
    fill_in "Description", with: @orders_buyout.description
    fill_in "Order status", with: @orders_buyout.order_status_id
    click_on "Update Orders buyout"

    assert_text "Orders buyout was successfully updated"
    click_on "Back"
  end

  test "should destroy Orders buyout" do
    visit orders_buyout_url(@orders_buyout)
    click_on "Destroy this orders buyout", match: :first

    assert_text "Orders buyout was successfully destroyed"
  end
end
