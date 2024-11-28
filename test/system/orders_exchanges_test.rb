require "application_system_test_case"

class OrdersExchangesTest < ApplicationSystemTestCase
  setup do
    @orders_exchange = orders_exchanges(:one)
  end

  test "visiting the index" do
    visit orders_exchanges_url
    assert_selector "h1", text: "Orders exchanges"
  end

  test "should create orders exchange" do
    visit orders_exchanges_url
    click_on "New orders exchange"

    fill_in "Description", with: @orders_exchange.description
    fill_in "Exchanges", with: @orders_exchange.exchanges_id
    fill_in "Order status", with: @orders_exchange.order_status_id
    click_on "Create Orders exchange"

    assert_text "Orders exchange was successfully created"
    click_on "Back"
  end

  test "should update Orders exchange" do
    visit orders_exchange_url(@orders_exchange)
    click_on "Edit this orders exchange", match: :first

    fill_in "Description", with: @orders_exchange.description
    fill_in "Exchanges", with: @orders_exchange.exchanges_id
    fill_in "Order status", with: @orders_exchange.order_status_id
    click_on "Update Orders exchange"

    assert_text "Orders exchange was successfully updated"
    click_on "Back"
  end

  test "should destroy Orders exchange" do
    visit orders_exchange_url(@orders_exchange)
    click_on "Destroy this orders exchange", match: :first

    assert_text "Orders exchange was successfully destroyed"
  end
end
