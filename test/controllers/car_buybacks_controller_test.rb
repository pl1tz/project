require "test_helper"

class CarBuybacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_buyback = car_buybacks(:one)
  end

  test "should get index" do
    get car_buybacks_url
    assert_response :success
  end

  test "should get new" do
    get new_car_buyback_url
    assert_response :success
  end

  test "should create car_buyback" do
    assert_difference("CarBuyback.count") do
      post car_buybacks_url, params: { car_buyback: { buyback_price: @car_buyback.buyback_price, car_id: @car_buyback.car_id, created_at: @car_buyback.created_at } }
    end

    assert_redirected_to car_buyback_url(CarBuyback.last)
  end

  test "should show car_buyback" do
    get car_buyback_url(@car_buyback)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_buyback_url(@car_buyback)
    assert_response :success
  end

  test "should update car_buyback" do
    patch car_buyback_url(@car_buyback), params: { car_buyback: { buyback_price: @car_buyback.buyback_price, car_id: @car_buyback.car_id, created_at: @car_buyback.created_at } }
    assert_redirected_to car_buyback_url(@car_buyback)
  end

  test "should destroy car_buyback" do
    assert_difference("CarBuyback.count", -1) do
      delete car_buyback_url(@car_buyback)
    end

    assert_redirected_to car_buybacks_url
  end
end
