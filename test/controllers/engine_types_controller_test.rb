require "test_helper"

class EngineTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @engine_type = engine_types(:one)
  end

  test "should get index" do
    get engine_types_url
    assert_response :success
  end

  test "should get new" do
    get new_engine_type_url
    assert_response :success
  end

  test "should create engine_type" do
    assert_difference("EngineType.count") do
      post engine_types_url, params: { engine_type: { engine_capacity: @engine_type.engine_capacity, engine_power: @engine_type.engine_power, name: @engine_type.name } }
    end

    assert_redirected_to engine_type_url(EngineType.last)
  end

  test "should show engine_type" do
    get engine_type_url(@engine_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_engine_type_url(@engine_type)
    assert_response :success
  end

  test "should update engine_type" do
    patch engine_type_url(@engine_type), params: { engine_type: { engine_capacity: @engine_type.engine_capacity, engine_power: @engine_type.engine_power, name: @engine_type.name } }
    assert_redirected_to engine_type_url(@engine_type)
  end

  test "should destroy engine_type" do
    assert_difference("EngineType.count", -1) do
      delete engine_type_url(@engine_type)
    end

    assert_redirected_to engine_types_url
  end
end
