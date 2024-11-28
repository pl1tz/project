require "test_helper"

class OrdersInstallmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orders_installment = orders_installments(:one)
  end

  test "should get index" do
    get orders_installments_url
    assert_response :success
  end

  test "should get new" do
    get new_orders_installment_url
    assert_response :success
  end

  test "should create orders_installment" do
    assert_difference("OrdersInstallment.count") do
      post orders_installments_url, params: { orders_installment: { description: @orders_installment.description, installment_id: @orders_installment.installment_id, order_status_id: @orders_installment.order_status_id } }
    end

    assert_redirected_to orders_installment_url(OrdersInstallment.last)
  end

  test "should show orders_installment" do
    get orders_installment_url(@orders_installment)
    assert_response :success
  end

  test "should get edit" do
    get edit_orders_installment_url(@orders_installment)
    assert_response :success
  end

  test "should update orders_installment" do
    patch orders_installment_url(@orders_installment), params: { orders_installment: { description: @orders_installment.description, installment_id: @orders_installment.installment_id, order_status_id: @orders_installment.order_status_id } }
    assert_redirected_to orders_installment_url(@orders_installment)
  end

  test "should destroy orders_installment" do
    assert_difference("OrdersInstallment.count", -1) do
      delete orders_installment_url(@orders_installment)
    end

    assert_redirected_to orders_installments_url
  end
end
