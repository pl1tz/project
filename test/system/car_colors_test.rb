require "application_system_test_case"

class CarColorsTest < ApplicationSystemTestCase
  setup do
    @car_color = car_colors(:one)
  end

  test "visiting the index" do
    visit car_colors_url
    assert_selector "h1", text: "Car colors"
  end

  test "should create car color" do
    visit car_colors_url
    click_on "New car color"

    fill_in "Background", with: @car_color.background
    fill_in "Carcatalog", with: @car_color.carcatalog_id
    fill_in "Image", with: @car_color.image
    fill_in "Name", with: @car_color.name
    click_on "Create Car color"

    assert_text "Car color was successfully created"
    click_on "Back"
  end

  test "should update Car color" do
    visit car_color_url(@car_color)
    click_on "Edit this car color", match: :first

    fill_in "Background", with: @car_color.background
    fill_in "Carcatalog", with: @car_color.carcatalog_id
    fill_in "Image", with: @car_color.image
    fill_in "Name", with: @car_color.name
    click_on "Update Car color"

    assert_text "Car color was successfully updated"
    click_on "Back"
  end

  test "should destroy Car color" do
    visit car_color_url(@car_color)
    click_on "Destroy this car color", match: :first

    assert_text "Car color was successfully destroyed"
  end
end
