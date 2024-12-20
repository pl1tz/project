require "test_helper"

class CarCatalogContentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_content = car_catalog_contents(:one)
  end

  test "should get index" do
    get car_catalog_contents_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_content_url
    assert_response :success
  end

  test "should create car_catalog_content" do
    assert_difference("CarCatalogContent.count") do
      post car_catalog_contents_url, params: { car_catalog_content: { car_catalog_id: @car_catalog_content.car_catalog_id, content: @car_catalog_content.content } }
    end

    assert_redirected_to car_catalog_content_url(CarCatalogContent.last)
  end

  test "should show car_catalog_content" do
    get car_catalog_content_url(@car_catalog_content)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_content_url(@car_catalog_content)
    assert_response :success
  end

  test "should update car_catalog_content" do
    patch car_catalog_content_url(@car_catalog_content), params: { car_catalog_content: { car_catalog_id: @car_catalog_content.car_catalog_id, content: @car_catalog_content.content } }
    assert_redirected_to car_catalog_content_url(@car_catalog_content)
  end

  test "should destroy car_catalog_content" do
    assert_difference("CarCatalogContent.count", -1) do
      delete car_catalog_content_url(@car_catalog_content)
    end

    assert_redirected_to car_catalog_contents_url
  end
end
