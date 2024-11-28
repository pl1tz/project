require "test_helper"

class BuyoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buyout = buyouts(:one)
  end

  test "should get index" do
    get buyouts_url
    assert_response :success
  end

  test "should get new" do
    get new_buyout_url
    assert_response :success
  end

  test "should create buyout" do
    assert_difference("Buyout.count") do
      post buyouts_url, params: { buyout: { brand: @buyout.brand, mileage: @buyout.mileage, model: @buyout.model, name: @buyout.name, phone: @buyout.phone, year: @buyout.year } }
    end

    assert_redirected_to buyout_url(Buyout.last)
  end

  test "should show buyout" do
    get buyout_url(@buyout)
    assert_response :success
  end

  test "should get edit" do
    get edit_buyout_url(@buyout)
    assert_response :success
  end

  test "should update buyout" do
    patch buyout_url(@buyout), params: { buyout: { brand: @buyout.brand, mileage: @buyout.mileage, model: @buyout.model, name: @buyout.name, phone: @buyout.phone, year: @buyout.year } }
    assert_redirected_to buyout_url(@buyout)
  end

  test "should destroy buyout" do
    assert_difference("Buyout.count", -1) do
      delete buyout_url(@buyout)
    end

    assert_redirected_to buyouts_url
  end
end
