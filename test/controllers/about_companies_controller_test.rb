require "test_helper"

class AboutCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @about_company = about_companies(:one)
  end

  test "should get index" do
    get about_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_about_company_url
    assert_response :success
  end

  test "should create about_company" do
    assert_difference("AboutCompany.count") do
      post about_companies_url, params: { about_company: { description: @about_company.description } }
    end

    assert_redirected_to about_company_url(AboutCompany.last)
  end

  test "should show about_company" do
    get about_company_url(@about_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_about_company_url(@about_company)
    assert_response :success
  end

  test "should update about_company" do
    patch about_company_url(@about_company), params: { about_company: { description: @about_company.description } }
    assert_redirected_to about_company_url(@about_company)
  end

  test "should destroy about_company" do
    assert_difference("AboutCompany.count", -1) do
      delete about_company_url(@about_company)
    end

    assert_redirected_to about_companies_url
  end
end
