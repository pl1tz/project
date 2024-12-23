require "application_system_test_case"

class CarCatalogOrdersTest < ApplicationSystemTestCase
  setup do
    @car_catalog_order = car_catalog_orders(:one)
  end

  test "visiting the index" do
    visit car_catalog_orders_url
    assert_selector "h1", text: "Car catalog orders"
  end

  test "should create car catalog order" do
    visit car_catalog_orders_url
    click_on "New car catalog order"

    fill_in "Car catalog", with: @car_catalog_order.car_catalog
    fill_in "Name", with: @car_catalog_order.name
    fill_in "Order status", with: @car_catalog_order.order_status_id
    fill_in "Phone", with: @car_catalog_order.phone
    click_on "Create Car catalog order"

    assert_text "Car catalog order was successfully created"
    click_on "Back"
  end

  test "should update Car catalog order" do
    visit car_catalog_order_url(@car_catalog_order)
    click_on "Edit this car catalog order", match: :first

    fill_in "Car catalog", with: @car_catalog_order.car_catalog
    fill_in "Name", with: @car_catalog_order.name
    fill_in "Order status", with: @car_catalog_order.order_status_id
    fill_in "Phone", with: @car_catalog_order.phone
    click_on "Update Car catalog order"

    assert_text "Car catalog order was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog order" do
    visit car_catalog_order_url(@car_catalog_order)
    click_on "Destroy this car catalog order", match: :first

    assert_text "Car catalog order was successfully destroyed"
  end
end
