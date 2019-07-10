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

  test "pagination" do
    SystemSettings::Configurator.new do |c|
      assert c.purge
      9.times do |n|
        c.string_list "aaa#{n}", value: "value#{n}"
      end
      9.times do |n|
        c.string_list "bbb#{n}", value: "value#{n}"
      end
      9.times do |n|
        c.string_list "ccc#{n}", value: "value#{n}"
      end
      9.times do |n|
        c.string_list "ddd#{n}", value: "value#{n}"
      end
      assert c.persist
    end
    visit "/system_settings"
    assert_text "aaa8"
    refute_text "ccc7"
    click_on "2"
    assert_text "ccc8"
    assert_text "ddd8"
    refute_text "aaa8"
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
    refresh_page
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
    wait_for_request_to_complete
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
    wait_for_request_to_complete
    assert_equal ["aaabbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    wait_for_request_to_complete
    assert_equal ["aaa", "bbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa\\;bbb", fill_options: { clear: :backspace }
    click_button "Save"
    wait_for_request_to_complete
    assert_equal ["aaa;bbb"], SystemSettings[:test_string_list]

    fill_in "Value", with: "aaa\\;bbb\\\\;ccc;ddd", fill_options: { clear: :backspace }
    click_button "Save"
    wait_for_request_to_complete
    assert_equal ["aaa;bbb\\;ccc", "ddd"], SystemSettings[:test_string_list]

    visit "/system_settings"
    click_on "test_string_list"
    assert_selector "span", text: "aaa;bbb\\;ccc"
    assert_selector "span", text: "ddd"
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
    assert_field "Value", with: "true"
    uncheck "Value"
    click_button "Save"
    wait_for_request_to_complete
    assert_equal false, SystemSettings[:bool_x]

    visit "/system_settings"
    click_on "bool_y"
    click_on "Edit"
    assert_field "Value", with: "false"
    check "Value"
    click_button "Save"
    wait_for_request_to_complete
    assert_equal true, SystemSettings[:bool_y]
  end

  private

  def wait_for_request_to_complete
    refute_selector "svg[data-role='save-spinner']"
  end

  def refresh_page
    page.driver.browser.navigate.refresh
  end
end
