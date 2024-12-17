require "test_helper"

class CarCatalogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog = car_catalogs(:one)
  end

  test "should get index" do
    get car_catalogs_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_url
    assert_response :success
  end

  test "should create car_catalog" do
    assert_difference("CarCatalog.count") do
      post car_catalogs_url, params: { car_catalog: { acceleration: @car_catalog.acceleration, brand: @car_catalog.brand, consumption: @car_catalog.consumption, max_speed: @car_catalog.max_speed, model: @car_catalog.model, power: @car_catalog.power } }
    end

    assert_redirected_to car_catalog_url(CarCatalog.last)
  end

  test "should show car_catalog" do
    get car_catalog_url(@car_catalog)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_url(@car_catalog)
    assert_response :success
  end

  test "should update car_catalog" do
    patch car_catalog_url(@car_catalog), params: { car_catalog: { acceleration: @car_catalog.acceleration, brand: @car_catalog.brand, consumption: @car_catalog.consumption, max_speed: @car_catalog.max_speed, model: @car_catalog.model, power: @car_catalog.power } }
    assert_redirected_to car_catalog_url(@car_catalog)
  end

  test "should destroy car_catalog" do
    assert_difference("CarCatalog.count", -1) do
      delete car_catalog_url(@car_catalog)
    end

    assert_redirected_to car_catalogs_url
  end
end
