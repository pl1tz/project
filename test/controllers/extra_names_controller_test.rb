require "test_helper"

class ExtraNamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @extra_name = extra_names(:one)
  end

  test "should get index" do
    get extra_names_url
    assert_response :success
  end

  test "should get new" do
    get new_extra_name_url
    assert_response :success
  end

  test "should create extra_name" do
    assert_difference("ExtraName.count") do
      post extra_names_url, params: { extra_name: { name: @extra_name.name } }
    end

    assert_redirected_to extra_name_url(ExtraName.last)
  end

  test "should show extra_name" do
    get extra_name_url(@extra_name)
    assert_response :success
  end

  test "should get edit" do
    get edit_extra_name_url(@extra_name)
    assert_response :success
  end

  test "should update extra_name" do
    patch extra_name_url(@extra_name), params: { extra_name: { name: @extra_name.name } }
    assert_redirected_to extra_name_url(@extra_name)
  end

  test "should destroy extra_name" do
    assert_difference("ExtraName.count", -1) do
      delete extra_name_url(@extra_name)
    end

    assert_redirected_to extra_names_url
  end
end
