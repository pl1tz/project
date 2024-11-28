require "test_helper"

class EnginePowerTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @engine_power_type = engine_power_types(:one)
  end

  test "should get index" do
    get engine_power_types_url
    assert_response :success
  end

  test "should get new" do
    get new_engine_power_type_url
    assert_response :success
  end

  test "should create engine_power_type" do
    assert_difference("EnginePowerType.count") do
      post engine_power_types_url, params: { engine_power_type: { power: @engine_power_type.power } }
    end

    assert_redirected_to engine_power_type_url(EnginePowerType.last)
  end

  test "should show engine_power_type" do
    get engine_power_type_url(@engine_power_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_engine_power_type_url(@engine_power_type)
    assert_response :success
  end

  test "should update engine_power_type" do
    patch engine_power_type_url(@engine_power_type), params: { engine_power_type: { power: @engine_power_type.power } }
    assert_redirected_to engine_power_type_url(@engine_power_type)
  end

  test "should destroy engine_power_type" do
    assert_difference("EnginePowerType.count", -1) do
      delete engine_power_type_url(@engine_power_type)
    end

    assert_redirected_to engine_power_types_url
  end
end
