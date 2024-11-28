require "test_helper"

class CreditProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit_program = credit_programs(:one)
  end

  test "should get index" do
    get credit_programs_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_program_url
    assert_response :success
  end

  test "should create credit_program" do
    assert_difference("CreditProgram.count") do
      post credit_programs_url, params: { credit_program: { bank_id: @credit_program.bank_id, created_at: @credit_program.created_at, interest_rate: @credit_program.interest_rate, max_amount: @credit_program.max_amount, max_term: @credit_program.max_term, program_name: @credit_program.program_name } }
    end

    assert_redirected_to credit_program_url(CreditProgram.last)
  end

  test "should show credit_program" do
    get credit_program_url(@credit_program)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_program_url(@credit_program)
    assert_response :success
  end

  test "should update credit_program" do
    patch credit_program_url(@credit_program), params: { credit_program: { bank_id: @credit_program.bank_id, created_at: @credit_program.created_at, interest_rate: @credit_program.interest_rate, max_amount: @credit_program.max_amount, max_term: @credit_program.max_term, program_name: @credit_program.program_name } }
    assert_redirected_to credit_program_url(@credit_program)
  end

  test "should destroy credit_program" do
    assert_difference("CreditProgram.count", -1) do
      delete credit_program_url(@credit_program)
    end

    assert_redirected_to credit_programs_url
  end
end
