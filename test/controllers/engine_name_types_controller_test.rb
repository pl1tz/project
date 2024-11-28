require "test_helper"

class EngineNameTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @engine_name_type = engine_name_types(:one)
  end

  test "should get index" do
    get engine_name_types_url
    assert_response :success
  end

  test "should get new" do
    get new_engine_name_type_url
    assert_response :success
  end

  test "should create engine_name_type" do
    assert_difference("EngineNameType.count") do
      post engine_name_types_url, params: { engine_name_type: { name: @engine_name_type.name } }
    end

    assert_redirected_to engine_name_type_url(EngineNameType.last)
  end

  test "should show engine_name_type" do
    get engine_name_type_url(@engine_name_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_engine_name_type_url(@engine_name_type)
    assert_response :success
  end

  test "should update engine_name_type" do
    patch engine_name_type_url(@engine_name_type), params: { engine_name_type: { name: @engine_name_type.name } }
    assert_redirected_to engine_name_type_url(@engine_name_type)
  end

  test "should destroy engine_name_type" do
    assert_difference("EngineNameType.count", -1) do
      delete engine_name_type_url(@engine_name_type)
    end

    assert_redirected_to engine_name_types_url
  end
end
