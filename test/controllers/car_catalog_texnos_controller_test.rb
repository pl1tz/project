require "test_helper"

class CarCatalogTexnosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_texno = car_catalog_texnos(:one)
  end

  test "should get index" do
    get car_catalog_texnos_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_texno_url
    assert_response :success
  end

  test "should create car_catalog_texno" do
    assert_difference("CarCatalogTexno.count") do
      post car_catalog_texnos_url, params: { car_catalog_texno: { height: @car_catalog_texno.height, image: @car_catalog_texno.image, length: @car_catalog_texno.length, width: @car_catalog_texno.width } }
    end

    assert_redirected_to car_catalog_texno_url(CarCatalogTexno.last)
  end

  test "should show car_catalog_texno" do
    get car_catalog_texno_url(@car_catalog_texno)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_texno_url(@car_catalog_texno)
    assert_response :success
  end

  test "should update car_catalog_texno" do
    patch car_catalog_texno_url(@car_catalog_texno), params: { car_catalog_texno: { height: @car_catalog_texno.height, image: @car_catalog_texno.image, length: @car_catalog_texno.length, width: @car_catalog_texno.width } }
    assert_redirected_to car_catalog_texno_url(@car_catalog_texno)
  end

  test "should destroy car_catalog_texno" do
    assert_difference("CarCatalogTexno.count", -1) do
      delete car_catalog_texno_url(@car_catalog_texno)
    end

    assert_redirected_to car_catalog_texnos_url
  end
end
