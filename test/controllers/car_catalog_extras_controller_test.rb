require "test_helper"

class CarCatalogExtrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_extra = car_catalog_extras(:one)
  end

  test "should get index" do
    get car_catalog_extras_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_extra_url
    assert_response :success
  end

  test "should create car_catalog_extra" do
    assert_difference("CarCatalogExtra.count") do
      post car_catalog_extras_url, params: { car_catalog_extra: { car_catalog_configuration_id: @car_catalog_extra.car_catalog_configuration_id, car_catalog_extra_group_id: @car_catalog_extra.car_catalog_extra_group_id, car_catalog_extra_name_id: @car_catalog_extra.car_catalog_extra_name_id } }
    end

    assert_redirected_to car_catalog_extra_url(CarCatalogExtra.last)
  end

  test "should show car_catalog_extra" do
    get car_catalog_extra_url(@car_catalog_extra)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_extra_url(@car_catalog_extra)
    assert_response :success
  end

  test "should update car_catalog_extra" do
    patch car_catalog_extra_url(@car_catalog_extra), params: { car_catalog_extra: { car_catalog_configuration_id: @car_catalog_extra.car_catalog_configuration_id, car_catalog_extra_group_id: @car_catalog_extra.car_catalog_extra_group_id, car_catalog_extra_name_id: @car_catalog_extra.car_catalog_extra_name_id } }
    assert_redirected_to car_catalog_extra_url(@car_catalog_extra)
  end

  test "should destroy car_catalog_extra" do
    assert_difference("CarCatalogExtra.count", -1) do
      delete car_catalog_extra_url(@car_catalog_extra)
    end

    assert_redirected_to car_catalog_extras_url
  end
end
