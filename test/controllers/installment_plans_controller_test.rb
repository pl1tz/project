require "test_helper"

class InstallmentPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @installment_plan = installment_plans(:one)
  end

  test "should get index" do
    get installment_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_installment_plan_url
    assert_response :success
  end

  test "should create installment_plan" do
    assert_difference("InstallmentPlan.count") do
      post installment_plans_url, params: { installment_plan: { bank_id: @installment_plan.bank_id } }
    end

    assert_redirected_to installment_plan_url(InstallmentPlan.last)
  end

  test "should show installment_plan" do
    get installment_plan_url(@installment_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_installment_plan_url(@installment_plan)
    assert_response :success
  end

  test "should update installment_plan" do
    patch installment_plan_url(@installment_plan), params: { installment_plan: { bank_id: @installment_plan.bank_id } }
    assert_redirected_to installment_plan_url(@installment_plan)
  end

  test "should destroy installment_plan" do
    assert_difference("InstallmentPlan.count", -1) do
      delete installment_plan_url(@installment_plan)
    end

    assert_redirected_to installment_plans_url
  end
end
