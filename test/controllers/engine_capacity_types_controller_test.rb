require "test_helper"

class EngineCapacityTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @engine_capacity_type = engine_capacity_types(:one)
  end

  test "should get index" do
    get engine_capacity_types_url
    assert_response :success
  end

  test "should get new" do
    get new_engine_capacity_type_url
    assert_response :success
  end

  test "should create engine_capacity_type" do
    assert_difference("EngineCapacityType.count") do
      post engine_capacity_types_url, params: { engine_capacity_type: { capacity: @engine_capacity_type.capacity } }
    end

    assert_redirected_to engine_capacity_type_url(EngineCapacityType.last)
  end

  test "should show engine_capacity_type" do
    get engine_capacity_type_url(@engine_capacity_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_engine_capacity_type_url(@engine_capacity_type)
    assert_response :success
  end

  test "should update engine_capacity_type" do
    patch engine_capacity_type_url(@engine_capacity_type), params: { engine_capacity_type: { capacity: @engine_capacity_type.capacity } }
    assert_redirected_to engine_capacity_type_url(@engine_capacity_type)
  end

  test "should destroy engine_capacity_type" do
    assert_difference("EngineCapacityType.count", -1) do
      delete engine_capacity_type_url(@engine_capacity_type)
    end

    assert_redirected_to engine_capacity_types_url
  end
end
