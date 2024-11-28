require "application_system_test_case"

class BuyoutsTest < ApplicationSystemTestCase
  setup do
    @buyout = buyouts(:one)
  end

  test "visiting the index" do
    visit buyouts_url
    assert_selector "h1", text: "Buyouts"
  end

  test "should create buyout" do
    visit buyouts_url
    click_on "New buyout"

    fill_in "Brand", with: @buyout.brand
    fill_in "Mileage", with: @buyout.mileage
    fill_in "Model", with: @buyout.model
    fill_in "Name", with: @buyout.name
    fill_in "Phone", with: @buyout.phone
    fill_in "Year", with: @buyout.year
    click_on "Create Buyout"

    assert_text "Buyout was successfully created"
    click_on "Back"
  end

  test "should update Buyout" do
    visit buyout_url(@buyout)
    click_on "Edit this buyout", match: :first

    fill_in "Brand", with: @buyout.brand
    fill_in "Mileage", with: @buyout.mileage
    fill_in "Model", with: @buyout.model
    fill_in "Name", with: @buyout.name
    fill_in "Phone", with: @buyout.phone
    fill_in "Year", with: @buyout.year
    click_on "Update Buyout"

    assert_text "Buyout was successfully updated"
    click_on "Back"
  end

  test "should destroy Buyout" do
    visit buyout_url(@buyout)
    click_on "Destroy this buyout", match: :first

    assert_text "Buyout was successfully destroyed"
  end
end
