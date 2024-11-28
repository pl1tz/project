require "application_system_test_case"

class AboutCompaniesTest < ApplicationSystemTestCase
  setup do
    @about_company = about_companies(:one)
  end

  test "visiting the index" do
    visit about_companies_url
    assert_selector "h1", text: "About companies"
  end

  test "should create about company" do
    visit about_companies_url
    click_on "New about company"

    fill_in "Description", with: @about_company.description
    click_on "Create About company"

    assert_text "About company was successfully created"
    click_on "Back"
  end

  test "should update About company" do
    visit about_company_url(@about_company)
    click_on "Edit this about company", match: :first

    fill_in "Description", with: @about_company.description
    click_on "Update About company"

    assert_text "About company was successfully updated"
    click_on "Back"
  end

  test "should destroy About company" do
    visit about_company_url(@about_company)
    click_on "Destroy this about company", match: :first

    assert_text "About company was successfully destroyed"
  end
end
