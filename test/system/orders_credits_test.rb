require "application_system_test_case"

class OrdersCreditsTest < ApplicationSystemTestCase
  setup do
    @orders_credit = orders_credits(:one)
  end

  test "visiting the index" do
    visit orders_credits_url
    assert_selector "h1", text: "Orders credits"
  end

  test "should create orders credit" do
    visit orders_credits_url
    click_on "New orders credit"

    fill_in "Credit", with: @orders_credit.credit_id
    fill_in "Description", with: @orders_credit.description
    fill_in "Order status", with: @orders_credit.order_status_id
    click_on "Create Orders credit"

    assert_text "Orders credit was successfully created"
    click_on "Back"
  end

  test "should update Orders credit" do
    visit orders_credit_url(@orders_credit)
    click_on "Edit this orders credit", match: :first

    fill_in "Credit", with: @orders_credit.credit_id
    fill_in "Description", with: @orders_credit.description
    fill_in "Order status", with: @orders_credit.order_status_id
    click_on "Update Orders credit"

    assert_text "Orders credit was successfully updated"
    click_on "Back"
  end

  test "should destroy Orders credit" do
    visit orders_credit_url(@orders_credit)
    click_on "Destroy this orders credit", match: :first

    assert_text "Orders credit was successfully destroyed"
  end
end
