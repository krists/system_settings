require "test_helper"

class SystemSettings::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, SystemSettings
  end

  test "SystemSettings[] accessor" do
    assert SystemSettings::Setting.where(name: "default_mail_from").exists?
    assert_equal "Example Company <noreply@example.com>", SystemSettings[:default_mail_from]
  end

  test "SystemSettings[] accessor with non-existing name" do
    assert_raise(ActiveRecord::RecordNotFound) do
      SystemSettings[:non_existing]
    end
  end
end
