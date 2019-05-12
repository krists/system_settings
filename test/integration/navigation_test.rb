require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  test "settings backend" do
    get "/system_settings"
    assert_response :success
    assert_select 'title', 'System Settings'
  end
end
