require "test_helper"

class CarCatalogOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_order = car_catalog_orders(:one)
  end

  test "should get index" do
    get car_catalog_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_order_url
    assert_response :success
  end

  test "should create car_catalog_order" do
    assert_difference("CarCatalogOrder.count") do
      post car_catalog_orders_url, params: { car_catalog_order: { car_catalog_id: @car_catalog_order.car_catalog_id, name: @car_catalog_order.name, phone: @car_catalog_order.phone } }
    end

    assert_redirected_to car_catalog_order_url(CarCatalogOrder.last)
  end

  test "should show car_catalog_order" do
    get car_catalog_order_url(@car_catalog_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_order_url(@car_catalog_order)
    assert_response :success
  end

  test "should update car_catalog_order" do
    patch car_catalog_order_url(@car_catalog_order), params: { car_catalog_order: { car_catalog_id: @car_catalog_order.car_catalog_id, name: @car_catalog_order.name, phone: @car_catalog_order.phone } }
    assert_redirected_to car_catalog_order_url(@car_catalog_order)
  end

  test "should destroy car_catalog_order" do
    assert_difference("CarCatalogOrder.count", -1) do
      delete car_catalog_order_url(@car_catalog_order)
    end

    assert_redirected_to car_catalog_orders_url
  end
end
