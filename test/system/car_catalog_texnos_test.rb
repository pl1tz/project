require "application_system_test_case"

class CarCatalogTexnosTest < ApplicationSystemTestCase
  setup do
    @car_catalog_texno = car_catalog_texnos(:one)
  end

  test "visiting the index" do
    visit car_catalog_texnos_url
    assert_selector "h1", text: "Car catalog texnos"
  end

  test "should create car catalog texno" do
    visit car_catalog_texnos_url
    click_on "New car catalog texno"

    fill_in "Height", with: @car_catalog_texno.height
    fill_in "Image", with: @car_catalog_texno.image
    fill_in "Length", with: @car_catalog_texno.length
    fill_in "Width", with: @car_catalog_texno.width
    click_on "Create Car catalog texno"

    assert_text "Car catalog texno was successfully created"
    click_on "Back"
  end

  test "should update Car catalog texno" do
    visit car_catalog_texno_url(@car_catalog_texno)
    click_on "Edit this car catalog texno", match: :first

    fill_in "Height", with: @car_catalog_texno.height
    fill_in "Image", with: @car_catalog_texno.image
    fill_in "Length", with: @car_catalog_texno.length
    fill_in "Width", with: @car_catalog_texno.width
    click_on "Update Car catalog texno"

    assert_text "Car catalog texno was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog texno" do
    visit car_catalog_texno_url(@car_catalog_texno)
    click_on "Destroy this car catalog texno", match: :first

    assert_text "Car catalog texno was successfully destroyed"
  end
end
