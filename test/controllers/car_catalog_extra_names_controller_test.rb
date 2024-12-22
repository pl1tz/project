require "test_helper"

class CarCatalogExtraNamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_extra_name = car_catalog_extra_names(:one)
  end

  test "should get index" do
    get car_catalog_extra_names_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_extra_name_url
    assert_response :success
  end

  test "should create car_catalog_extra_name" do
    assert_difference("CarCatalogExtraName.count") do
      post car_catalog_extra_names_url, params: { car_catalog_extra_name: { name: @car_catalog_extra_name.name } }
    end

    assert_redirected_to car_catalog_extra_name_url(CarCatalogExtraName.last)
  end

  test "should show car_catalog_extra_name" do
    get car_catalog_extra_name_url(@car_catalog_extra_name)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_extra_name_url(@car_catalog_extra_name)
    assert_response :success
  end

  test "should update car_catalog_extra_name" do
    patch car_catalog_extra_name_url(@car_catalog_extra_name), params: { car_catalog_extra_name: { name: @car_catalog_extra_name.name } }
    assert_redirected_to car_catalog_extra_name_url(@car_catalog_extra_name)
  end

  test "should destroy car_catalog_extra_name" do
    assert_difference("CarCatalogExtraName.count", -1) do
      delete car_catalog_extra_name_url(@car_catalog_extra_name)
    end

    assert_redirected_to car_catalog_extra_names_url
  end
end
