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
    begin
      assert_kind_of Pathname, SystemSettings.settings_file_path
      original_value = SystemSettings.settings_file_path
      assert_match(/config\/system_settings\.rb$/, SystemSettings.settings_file_path.to_s)
      SystemSettings.settings_file_path = "/changed/path.rb"
      assert_equal "/changed/path.rb", SystemSettings.settings_file_path
    ensure
      SystemSettings.settings_file_path = original_value
    end
  end

  test "load" do
    begin
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
  end

  test "load with non-existing path" do
    begin
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
  end

  test "reset_to_defaults" do
    begin
      original_value = SystemSettings.settings_file_path
      SystemSettings.settings_file_path = "/changed/path2.rb"
      mock = MiniTest::Mock.new
      mock.expect(:purge, true)
      mock.expect(:persist, true)
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

  test "instrumentation" do
    begin
      original_instrumenter = SystemSettings.instrumenter
      mock = MiniTest::Mock.new
      mock.expect(:instrument, nil, ["system_settings.find", {name: :default_records_per_page}])
      SystemSettings.instrumenter = mock
      SystemSettings[:default_records_per_page]
      mock.verify
    ensure
      SystemSettings.instrumenter = original_instrumenter
    end
  end

  test "instrumentation disabled" do
    begin
      original_instrumenter = SystemSettings.instrumenter
      instrument_proc = lambda do |_, _|
        raise "Should never be called"
      end
      original_instrumenter.stub(:instrument, instrument_proc) do
        SystemSettings.instrumenter = nil
        SystemSettings[:default_records_per_page]
      end
    ensure
      SystemSettings.instrumenter = original_instrumenter
    end
  end
end
