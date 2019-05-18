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

  test "reload single setting view" do
    setting = SystemSettings::Setting.find_by(name: "default_mail_from")
    visit "/system_settings/settings/#{setting.id}"
    assert_text "default_mail_from"
    assert_text "Example Company <noreply@example.com>"
    refute_text "Changed Company <noreply@example.com>"
    assert setting.update(value: "Changed Company <noreply@example.com>")
    page.driver.browser.navigate.refresh
    assert_text "default_mail_from"
    assert_text "Changed Company <noreply@example.com>"
  end

  test "edit setting" do
    visit "/system_settings"
    click_on "default_mail_from"
    click_on "Edit"
    assert_field "Value", with: "Example Company <noreply@example.com>"
    fill_in "Value", with: "Admin <admin@example.com>", fill_options: { clear: :backspace } # https://github.com/erikras/redux-form/issues/686
    assert_field "Value", with: "Admin <admin@example.com>"
    click_button "Save"
    refute_selector "svg[data-role='save-spinner']"
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
    refute_selector "svg[data-role='save-spinner']"
    assert_equal ["aaabbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    refute_selector "svg[data-role='save-spinner']"
    assert_equal ["aaa", "bbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa\\;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    refute_selector "svg[data-role='save-spinner']"
    assert_equal ["aaa;bbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa\\;bbb\\\\;ccc;ddd", fill_options: { clear: :backspace }
    click_button "Save"
    refute_selector "svg[data-role='save-spinner']"
    assert_equal ["aaa;bbb\\;ccc", "ddd"], SystemSettings[:test_string_list]

    visit "/system_settings"
    click_on "test_string_list"
    assert_selector "span", text: "aaa;bbb\\;ccc"
    assert_selector "span", text: "ddd"
  end
end
