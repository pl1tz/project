require "application_system_test_case"

class CarCatalogContentsTest < ApplicationSystemTestCase
  setup do
    @car_catalog_content = car_catalog_contents(:one)
  end

  test "visiting the index" do
    visit car_catalog_contents_url
    assert_selector "h1", text: "Car catalog contents"
  end

  test "should create car catalog content" do
    visit car_catalog_contents_url
    click_on "New car catalog content"

    fill_in "Car catalog", with: @car_catalog_content.car_catalog_id
    fill_in "Content", with: @car_catalog_content.content
    click_on "Create Car catalog content"

    assert_text "Car catalog content was successfully created"
    click_on "Back"
  end

  test "should update Car catalog content" do
    visit car_catalog_content_url(@car_catalog_content)
    click_on "Edit this car catalog content", match: :first

    fill_in "Car catalog", with: @car_catalog_content.car_catalog_id
    fill_in "Content", with: @car_catalog_content.content
    click_on "Update Car catalog content"

    assert_text "Car catalog content was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog content" do
    visit car_catalog_content_url(@car_catalog_content)
    click_on "Destroy this car catalog content", match: :first

    assert_text "Car catalog content was successfully destroyed"
  end
end
