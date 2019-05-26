require "test_helper"

class SystemSettings::Test < ActiveSupport::TestCase
  test "SystemSettings[] accessor" do
    assert SystemSettings::Setting.where(name: "default_mail_from").exists?
    assert_equal "Example Company <noreply@example.com>", SystemSettings[:default_mail_from]
  end

  test "SystemSettings[] accessor with non-existing name" do
    error = assert_raise(SystemSettings::Errors::NotFoundError) do
      SystemSettings[:non_existing]
    end
    assert_equal "Couldn't find system setting non_existing", error.message
  end

  test "settings_file_path" do
    assert_kind_of Pathname, SystemSettings.settings_file_path
    original_value = SystemSettings.settings_file_path
    assert_match(/config\/system_settings\.rb$/, SystemSettings.settings_file_path.to_s)
    SystemSettings.settings_file_path = "/changed/path.rb"
    assert_equal "/changed/path.rb", SystemSettings.settings_file_path
  ensure
    SystemSettings.settings_file_path = original_value
  end

  test "load" do
    original_value = SystemSettings.settings_file_path
    SystemSettings.settings_file_path = "/changed/path.rb"
    mock = MiniTest::Mock.new
    mock.expect(:persist, nil)
    from_file_method_proc = lambda do |path|
      assert_equal "/changed/path.rb", path
      mock
    end
    SystemSettings::Configurator.stub(:from_file, from_file_method_proc) do
      SystemSettings.load
    end
    mock.verify
  ensure
    SystemSettings.settings_file_path = original_value
  end

  test "load with non-existing path" do
    original_value = SystemSettings.settings_file_path
    tempfile = Tempfile.new(%w[non-existing-settings .rb])
    path = tempfile.path
    tempfile.close
    assert tempfile.unlink
    refute File.exist?(path)
    SystemSettings.settings_file_path = tempfile.path
    assert_raises SystemSettings::Errors::SettingsReadError do
      SystemSettings.load
    end
  ensure
    SystemSettings.settings_file_path = original_value
  end

  test "reset_to_defaults" do
    original_value = SystemSettings.settings_file_path
    SystemSettings.settings_file_path = "/changed/path2.rb"
    mock = MiniTest::Mock.new
    mock.expect(:purge, nil)
    mock.expect(:persist, nil)
    from_file_method_proc = lambda do |path|
      assert_equal "/changed/path2.rb", path
      mock
    end
    SystemSettings::Configurator.stub(:from_file, from_file_method_proc) do
      SystemSettings.reset_to_defaults
    end
    mock.verify
  ensure
    SystemSettings.settings_file_path = original_value
  end
end
