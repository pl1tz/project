require "test_helper"

class CarCatalogEnginesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_engine = car_catalog_engines(:one)
  end

  test "should get index" do
    get car_catalog_engines_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_engine_url
    assert_response :success
  end

  test "should create car_catalog_engine" do
    assert_difference("CarCatalogEngine.count") do
      post car_catalog_engines_url, params: { car_catalog_engine: { car_catalog_id: @car_catalog_engine.car_catalog_id, cylinders: @car_catalog_engine.cylinders, engine_type: @car_catalog_engine.engine_type, engine_volume: @car_catalog_engine.engine_volume, fuel_type: @car_catalog_engine.fuel_type, power: @car_catalog_engine.power, torque: @car_catalog_engine.torque } }
    end

    assert_redirected_to car_catalog_engine_url(CarCatalogEngine.last)
  end

  test "should show car_catalog_engine" do
    get car_catalog_engine_url(@car_catalog_engine)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_engine_url(@car_catalog_engine)
    assert_response :success
  end

  test "should update car_catalog_engine" do
    patch car_catalog_engine_url(@car_catalog_engine), params: { car_catalog_engine: { car_catalog_id: @car_catalog_engine.car_catalog_id, cylinders: @car_catalog_engine.cylinders, engine_type: @car_catalog_engine.engine_type, engine_volume: @car_catalog_engine.engine_volume, fuel_type: @car_catalog_engine.fuel_type, power: @car_catalog_engine.power, torque: @car_catalog_engine.torque } }
    assert_redirected_to car_catalog_engine_url(@car_catalog_engine)
  end

  test "should destroy car_catalog_engine" do
    assert_difference("CarCatalogEngine.count", -1) do
      delete car_catalog_engine_url(@car_catalog_engine)
    end

    assert_redirected_to car_catalog_engines_url
  end
end
