require "application_system_test_case"

class OrdersInstallmentsTest < ApplicationSystemTestCase
  setup do
    @orders_installment = orders_installments(:one)
  end

  test "visiting the index" do
    visit orders_installments_url
    assert_selector "h1", text: "Orders installments"
  end

  test "should create orders installment" do
    visit orders_installments_url
    click_on "New orders installment"

    fill_in "Description", with: @orders_installment.description
    fill_in "Installment", with: @orders_installment.installment_id
    fill_in "Order status", with: @orders_installment.order_status_id
    click_on "Create Orders installment"

    assert_text "Orders installment was successfully created"
    click_on "Back"
  end

  test "should update Orders installment" do
    visit orders_installment_url(@orders_installment)
    click_on "Edit this orders installment", match: :first

    fill_in "Description", with: @orders_installment.description
    fill_in "Installment", with: @orders_installment.installment_id
    fill_in "Order status", with: @orders_installment.order_status_id
    click_on "Update Orders installment"

    assert_text "Orders installment was successfully updated"
    click_on "Back"
  end

  test "should destroy Orders installment" do
    visit orders_installment_url(@orders_installment)
    click_on "Destroy this orders installment", match: :first

    assert_text "Orders installment was successfully destroyed"
  end
end
