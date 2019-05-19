require "test_helper"

module SystemSettings
  class ConfiguratorTest < ActiveSupport::TestCase

    test "load items from file" do
      file = Tempfile.new(%w[system_settings_test .rb])
      file.write <<-RUBY
        string "default_mail_from", value: "changed value", description: "changed description"
        integer "classifier_x", value: 123
      RUBY
      file.close
      assert_equal 2, SystemSettings::Setting.count
      record_before_load = SystemSettings::Setting.find_by(name: "default_mail_from")
      assert_nil SystemSettings::Setting.find_by(name: "classifier_x")
      assert_equal "Example Company <noreply@example.com>", record_before_load.value
      assert_equal "This email will be used for all outgoing emails", record_before_load.description
      configurator = Configurator.from_file(file.path)
      assert_equal 2, configurator.items.size
      assert_equal 2, SystemSettings::Setting.count
      configurator.persist
      assert_equal 3, SystemSettings::Setting.count
      record_after_load = SystemSettings::Setting.find_by(name: "default_mail_from")
      assert_equal record_before_load.id, record_after_load.id
      assert_equal "Example Company <noreply@example.com>", record_after_load.value
      assert_equal "changed description", record_after_load.description
      assert_equal 123, SystemSettings[:classifier_x]
    ensure
      file.close unless file.closed?
      file.unlink
    end

    test "purge" do
      assert_equal 2, SystemSettings::Setting.count
      Configurator.new.purge
      assert_equal 0, SystemSettings::Setting.count
    end

    test "load from block" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.string_list :test_string_list, value: "123;456"
        assert c.persist
      end
      assert_equal %w[123 456], SystemSettings[:test_string_list]
    end

    test "integer list setting" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.integer_list :foo, value: []
        c.integer_list :bar, value: [11, 22, 33]
        assert c.persist
      end
      assert_equal [], SystemSettings[:foo]
      assert_equal [11, 22, 33], SystemSettings[:bar]
    end
  end
end
