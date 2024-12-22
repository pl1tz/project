require "test_helper"

class CarCatalogExtraGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_extra_group = car_catalog_extra_groups(:one)
  end

  test "should get index" do
    get car_catalog_extra_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_extra_group_url
    assert_response :success
  end

  test "should create car_catalog_extra_group" do
    assert_difference("CarCatalogExtraGroup.count") do
      post car_catalog_extra_groups_url, params: { car_catalog_extra_group: { name: @car_catalog_extra_group.name } }
    end

    assert_redirected_to car_catalog_extra_group_url(CarCatalogExtraGroup.last)
  end

  test "should show car_catalog_extra_group" do
    get car_catalog_extra_group_url(@car_catalog_extra_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_extra_group_url(@car_catalog_extra_group)
    assert_response :success
  end

  test "should update car_catalog_extra_group" do
    patch car_catalog_extra_group_url(@car_catalog_extra_group), params: { car_catalog_extra_group: { name: @car_catalog_extra_group.name } }
    assert_redirected_to car_catalog_extra_group_url(@car_catalog_extra_group)
  end

  test "should destroy car_catalog_extra_group" do
    assert_difference("CarCatalogExtraGroup.count", -1) do
      delete car_catalog_extra_group_url(@car_catalog_extra_group)
    end

    assert_redirected_to car_catalog_extra_groups_url
  end
end
