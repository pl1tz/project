require "test_helper"

class BodyTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @body_type = body_types(:one)
  end

  test "should get index" do
    get body_types_url
    assert_response :success
  end

  test "should get new" do
    get new_body_type_url
    assert_response :success
  end

  test "should create body_type" do
    assert_difference("BodyType.count") do
      post body_types_url, params: { body_type: { name: @body_type.name } }
    end

    assert_redirected_to body_type_url(BodyType.last)
  end

  test "should show body_type" do
    get body_type_url(@body_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_body_type_url(@body_type)
    assert_response :success
  end

  test "should update body_type" do
    patch body_type_url(@body_type), params: { body_type: { name: @body_type.name } }
    assert_redirected_to body_type_url(@body_type)
  end

  test "should destroy body_type" do
    assert_difference("BodyType.count", -1) do
      delete body_type_url(@body_type)
    end

    assert_redirected_to body_types_url
  end
end
