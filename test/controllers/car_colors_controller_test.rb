require "test_helper"

class CarColorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_color = car_colors(:one)
  end

  test "should get index" do
    get car_colors_url
    assert_response :success
  end

  test "should get new" do
    get new_car_color_url
    assert_response :success
  end

  test "should create car_color" do
    assert_difference("CarColor.count") do
      post car_colors_url, params: { car_color: { background: @car_color.background, carcatalog_id: @car_color.carcatalog_id, image: @car_color.image, name: @car_color.name } }
    end

    assert_redirected_to car_color_url(CarColor.last)
  end

  test "should show car_color" do
    get car_color_url(@car_color)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_color_url(@car_color)
    assert_response :success
  end

  test "should update car_color" do
    patch car_color_url(@car_color), params: { car_color: { background: @car_color.background, carcatalog_id: @car_color.carcatalog_id, image: @car_color.image, name: @car_color.name } }
    assert_redirected_to car_color_url(@car_color)
  end

  test "should destroy car_color" do
    assert_difference("CarColor.count", -1) do
      delete car_color_url(@car_color)
    end

    assert_redirected_to car_colors_url
  end
end
