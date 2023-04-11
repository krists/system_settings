require "application_system_test_case"

class CreateReadUpdateDeleteTest < ApplicationSystemTestCase
  test "empty list" do
    SystemSettings::Configurator.purge
    visit "/system_settings"
    assert_selector "a", text: "System Settings"
    assert_text "No settings"
    refute_text "default_mail_from"
  end

  test "list of loaded settings" do
    visit "/system_settings"
    assert_text "default_mail_from"
    assert_text "Example Company <noreply@example.com>"
    assert_text "This email will be used for all outgoing emails"
    assert_text "default_records_per_page"
    assert_text "50"
  end

  test "view single setting" do
    visit "/system_settings"
    assert_text "default_mail_from"
    assert_text "default_records_per_page"
    click_on "default_mail_from"
    refute_current_path "/system_settings"
    assert_match(/\/system_settings\/settings\/\d+/, current_path)
    assert_text "Edit"
    assert_text "Back"
    refute_text "default_records_per_page"
  end

  test "edit setting" do
    visit "/system_settings"
    click_on "default_mail_from"
    click_on "Edit"
    assert_field "Value", with: "Example Company <noreply@example.com>"
    fill_in "Value", with: "Admin <admin@example.com>", fill_options: { clear: :backspace } # https://github.com/erikras/redux-form/issues/686
    assert_field "Value", with: "Admin <admin@example.com>"
    click_button "Save"
    assert_equal "Admin <admin@example.com>", SystemSettings[:default_mail_from]
  end

  test "edit same setting multiple times and then view it" do
    SystemSettings::Configurator.new do |c|
      c.string_list :test_string_list, value: ["123;456"]
      assert c.persist
    end

    visit "/system_settings"
    click_on "test_string_list"
    click_on "Edit"
    assert_field "Value", with: "123\\;456"

    fill_in "Value", with: "aaabbb", fill_options: { clear: :backspace }
    click_button "Save"
    assert_equal ["aaabbb"], SystemSettings[:test_string_list]

    click_on "Edit"
    fill_in "Value", with: "aaa;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    assert_equal ["aaa", "bbb"], SystemSettings[:test_string_list]

    click_on "Edit"
    fill_in "Value", with: "aaa\\;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    assert_equal ["aaa;bbb"], SystemSettings[:test_string_list]

    click_on "Edit"
    fill_in "Value", with: "aaa\\;bbb\\\\;ccc;ddd", fill_options: { clear: :backspace }
    click_button "Save"
    assert_equal ["aaa;bbb\\;ccc", "ddd"], SystemSettings[:test_string_list]

    visit "/system_settings"
    click_on "test_string_list"
    assert_selector "span", text: "aaa;bbb\\;ccc"
    assert_selector "span", text: "ddd"
  end

  test "validations" do
    visit "/system_settings"
    click_on "default_mail_from"
    click_on "Edit"
    assert_field "Value", with: "Example Company <noreply@example.com>"
    fill_in "Value", with: "", fill_options: { clear: :backspace }
    click_button "Save"
    assert_text /can'|’t be blank/
    assert_equal "Example Company <noreply@example.com>", SystemSettings[:default_mail_from]
  end

  test "boolean setting" do
    SystemSettings::Configurator.new do |c|
      c.boolean :bool_x, value: true
      c.boolean :bool_y, value: false
      assert c.persist
    end

    assert_equal true, SystemSettings[:bool_x]
    assert_equal false, SystemSettings[:bool_y]

    visit "/system_settings"
    click_on "bool_x"
    click_on "Edit"
    assert_checked_field "Value"
    uncheck "Value"
    click_button "Save"
    assert_equal false, SystemSettings[:bool_x]

    visit "/system_settings"
    click_on "bool_y"
    click_on "Edit"
    refute_checked_field "Value"
    check "Value"
    click_button "Save"
    assert_equal true, SystemSettings[:bool_y]
  end

  private

  def refresh_page
    page.driver.browser.navigate.refresh
  end
end
