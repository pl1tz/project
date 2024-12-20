require "test_helper"

class CarCatalogConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car_catalog_configuration = car_catalog_configurations(:one)
  end

  test "should get index" do
    get car_catalog_configurations_url
    assert_response :success
  end

  test "should get new" do
    get new_car_catalog_configuration_url
    assert_response :success
  end

  test "should create car_catalog_configuration" do
    assert_difference("CarCatalogConfiguration.count") do
      post car_catalog_configurations_url, params: { car_catalog_configuration: { car_catalog_id: @car_catalog_configuration.car_catalog_id, credit_discount: @car_catalog_configuration.credit_discount, package_group: @car_catalog_configuration.package_group, package_name: @car_catalog_configuration.package_name, power: @car_catalog_configuration.power, price: @car_catalog_configuration.price, recycling_discount: @car_catalog_configuration.recycling_discount, special_price: @car_catalog_configuration.special_price, trade_in_discount: @car_catalog_configuration.trade_in_discount, transmission: @car_catalog_configuration.transmission, volume: @car_catalog_configuration.volume } }
    end

    assert_redirected_to car_catalog_configuration_url(CarCatalogConfiguration.last)
  end

  test "should show car_catalog_configuration" do
    get car_catalog_configuration_url(@car_catalog_configuration)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_catalog_configuration_url(@car_catalog_configuration)
    assert_response :success
  end

  test "should update car_catalog_configuration" do
    patch car_catalog_configuration_url(@car_catalog_configuration), params: { car_catalog_configuration: { car_catalog_id: @car_catalog_configuration.car_catalog_id, credit_discount: @car_catalog_configuration.credit_discount, package_group: @car_catalog_configuration.package_group, package_name: @car_catalog_configuration.package_name, power: @car_catalog_configuration.power, price: @car_catalog_configuration.price, recycling_discount: @car_catalog_configuration.recycling_discount, special_price: @car_catalog_configuration.special_price, trade_in_discount: @car_catalog_configuration.trade_in_discount, transmission: @car_catalog_configuration.transmission, volume: @car_catalog_configuration.volume } }
    assert_redirected_to car_catalog_configuration_url(@car_catalog_configuration)
  end

  test "should destroy car_catalog_configuration" do
    assert_difference("CarCatalogConfiguration.count", -1) do
      delete car_catalog_configuration_url(@car_catalog_configuration)
    end

    assert_redirected_to car_catalog_configurations_url
  end
end
