require "test_helper"

class CarCatalogImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_image = car_catalog_images(:one)
  end

  test "should get index" do
    get car_catalog_images_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_image_url
    assert_response :success
  end

  test "should create car_catalog_image" do
    assert_difference("CarCatalogImage.count") do
      post car_catalog_images_url, params: { car_catalog_image: { car_catalog_id: @car_catalog_image.car_catalog_id, url: @car_catalog_image.url } }
    end

    assert_redirected_to car_catalog_image_url(CarCatalogImage.last)
  end

  test "should show car_catalog_image" do
    get car_catalog_image_url(@car_catalog_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_image_url(@car_catalog_image)
    assert_response :success
  end

  test "should update car_catalog_image" do
    patch car_catalog_image_url(@car_catalog_image), params: { car_catalog_image: { car_catalog_id: @car_catalog_image.car_catalog_id, url: @car_catalog_image.url } }
    assert_redirected_to car_catalog_image_url(@car_catalog_image)
  end

  test "should destroy car_catalog_image" do
    assert_difference("CarCatalogImage.count", -1) do
      delete car_catalog_image_url(@car_catalog_image)
    end

    assert_redirected_to car_catalog_images_url
  end
end
