require "test_helper"

class GearboxTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gearbox_type = gearbox_types(:one)
  end

  test "should get index" do
    get gearbox_types_url
    assert_response :success
  end

  test "should get new" do
    get new_gearbox_type_url
    assert_response :success
  end

  test "should create gearbox_type" do
    assert_difference("GearboxType.count") do
      post gearbox_types_url, params: { gearbox_type: { name: @gearbox_type.name } }
    end

    assert_redirected_to gearbox_type_url(GearboxType.last)
  end

  test "should show gearbox_type" do
    get gearbox_type_url(@gearbox_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_gearbox_type_url(@gearbox_type)
    assert_response :success
  end

  test "should update gearbox_type" do
    patch gearbox_type_url(@gearbox_type), params: { gearbox_type: { name: @gearbox_type.name } }
    assert_redirected_to gearbox_type_url(@gearbox_type)
  end

  test "should destroy gearbox_type" do
    assert_difference("GearboxType.count", -1) do
      delete gearbox_type_url(@gearbox_type)
    end

    assert_redirected_to gearbox_types_url
  end
end
