require "application_system_test_case"

class CarCatalogImagesTest < ApplicationSystemTestCase
  setup do
    @car_catalog_image = car_catalog_images(:one)
  end

  test "visiting the index" do
    visit car_catalog_images_url
    assert_selector "h1", text: "Car catalog images"
  end

  test "should create car catalog image" do
    visit car_catalog_images_url
    click_on "New car catalog image"

    fill_in "Car catalog", with: @car_catalog_image.car_catalog_id
    fill_in "Url", with: @car_catalog_image.url
    click_on "Create Car catalog image"

    assert_text "Car catalog image was successfully created"
    click_on "Back"
  end

  test "should update Car catalog image" do
    visit car_catalog_image_url(@car_catalog_image)
    click_on "Edit this car catalog image", match: :first

    fill_in "Car catalog", with: @car_catalog_image.car_catalog_id
    fill_in "Url", with: @car_catalog_image.url
    click_on "Update Car catalog image"

    assert_text "Car catalog image was successfully updated"
    click_on "Back"
  end

  test "should destroy Car catalog image" do
    visit car_catalog_image_url(@car_catalog_image)
    click_on "Destroy this car catalog image", match: :first

    assert_text "Car catalog image was successfully destroyed"
  end
end
