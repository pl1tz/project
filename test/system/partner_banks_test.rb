require "application_system_test_case"

class PartnerBanksTest < ApplicationSystemTestCase
  setup do
    @partner_bank = partner_banks(:one)
  end

  test "visiting the index" do
    visit partner_banks_url
    assert_selector "h1", text: "Partner banks"
  end

  test "should create partner bank" do
    visit partner_banks_url
    click_on "New partner bank"

    fill_in "Country", with: @partner_bank.country
    fill_in "Created at", with: @partner_bank.created_at
    fill_in "Name", with: @partner_bank.name
    click_on "Create Partner bank"

    assert_text "Partner bank was successfully created"
    click_on "Back"
  end

  test "should update Partner bank" do
    visit partner_bank_url(@partner_bank)
    click_on "Edit this partner bank", match: :first

    fill_in "Country", with: @partner_bank.country
    fill_in "Created at", with: @partner_bank.created_at.to_s
    fill_in "Name", with: @partner_bank.name
    click_on "Update Partner bank"

    assert_text "Partner bank was successfully updated"
    click_on "Back"
  end

  test "should destroy Partner bank" do
    visit partner_bank_url(@partner_bank)
    click_on "Destroy this partner bank", match: :first

    assert_text "Partner bank was successfully destroyed"
  end
end
