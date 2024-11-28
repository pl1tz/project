require "test_helper"

class ExtrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @extra = extras(:one)
  end

  test "should get index" do
    get extras_url
    assert_response :success
  end

  test "should get new" do
    get new_extra_url
    assert_response :success
  end

  test "should create extra" do
    assert_difference("Extra.count") do
      post extras_url, params: { extra: { car_id: @extra.car_id, category_id: @extra.category_id, name: @extra.name } }
    end

    assert_redirected_to extra_url(Extra.last)
  end

  test "should show extra" do
    get extra_url(@extra)
    assert_response :success
  end

  test "should get edit" do
    get edit_extra_url(@extra)
    assert_response :success
  end

  test "should update extra" do
    patch extra_url(@extra), params: { extra: { car_id: @extra.car_id, category_id: @extra.category_id, name: @extra.name } }
    assert_redirected_to extra_url(@extra)
  end

  test "should destroy extra" do
    assert_difference("Extra.count", -1) do
      delete extra_url(@extra)
    end

    assert_redirected_to extras_url
  end
end
