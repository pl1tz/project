require "test_helper"

class DriveTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @drive_type = drive_types(:one)
  end

  test "should get index" do
    get drive_types_url
    assert_response :success
  end

  test "should get new" do
    get new_drive_type_url
    assert_response :success
  end

  test "should create drive_type" do
    assert_difference("DriveType.count") do
      post drive_types_url, params: { drive_type: { name: @drive_type.name } }
    end

    assert_redirected_to drive_type_url(DriveType.last)
  end

  test "should show drive_type" do
    get drive_type_url(@drive_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_drive_type_url(@drive_type)
    assert_response :success
  end

  test "should update drive_type" do
    patch drive_type_url(@drive_type), params: { drive_type: { name: @drive_type.name } }
    assert_redirected_to drive_type_url(@drive_type)
  end

  test "should destroy drive_type" do
    assert_difference("DriveType.count", -1) do
      delete drive_type_url(@drive_type)
    end

    assert_redirected_to drive_types_url
  end
end
