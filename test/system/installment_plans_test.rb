require "application_system_test_case"

class InstallmentPlansTest < ApplicationSystemTestCase
  setup do
    @installment_plan = installment_plans(:one)
  end

  test "visiting the index" do
    visit installment_plans_url
    assert_selector "h1", text: "Installment plans"
  end

  test "should create installment plan" do
    visit installment_plans_url
    click_on "New installment plan"

    fill_in "Bank", with: @installment_plan.bank_id
    click_on "Create Installment plan"

    assert_text "Installment plan was successfully created"
    click_on "Back"
  end

  test "should update Installment plan" do
    visit installment_plan_url(@installment_plan)
    click_on "Edit this installment plan", match: :first

    fill_in "Bank", with: @installment_plan.bank_id
    click_on "Update Installment plan"

    assert_text "Installment plan was successfully updated"
    click_on "Back"
  end

  test "should destroy Installment plan" do
    visit installment_plan_url(@installment_plan)
    click_on "Destroy this installment plan", match: :first

    assert_text "Installment plan was successfully destroyed"
  end
end
