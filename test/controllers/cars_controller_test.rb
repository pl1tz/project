require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car = cars(:one)
  end

  test "should get index" do
    get cars_url
    assert_response :success
  end

  test "should get new" do
    get new_car_url
    assert_response :success
  end

  test "should create car" do
    assert_difference("Car.count") do
      post cars_url, params: { car: { body_type_id: @car.body_type_id, brand_id: @car.brand_id, color_id: @car.color_id, description: @car.description, drive_type_id: @car.drive_type_id, engine_type_id: @car.engine_type_id, fuel_type_id: @car.fuel_type_id, gearbox_type_id: @car.gearbox_type_id, model_id: @car.model_id, price: @car.price, year: @car.year } }
    end

    assert_redirected_to car_url(Car.last)
  end

  test "should show car" do
    get car_url(@car)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_url(@car)
    assert_response :success
  end

  test "should update car" do
    patch car_url(@car), params: { car: { body_type_id: @car.body_type_id, brand_id: @car.brand_id, color_id: @car.color_id, description: @car.description, drive_type_id: @car.drive_type_id, engine_type_id: @car.engine_type_id, fuel_type_id: @car.fuel_type_id, gearbox_type_id: @car.gearbox_type_id, model_id: @car.model_id, price: @car.price, year: @car.year } }
    assert_redirected_to car_url(@car)
  end

  test "should destroy car" do
    assert_difference("Car.count", -1) do
      delete car_url(@car)
    end

    assert_redirected_to cars_url
  end
end
