require "test_helper"

module SystemSettings
  class ConfiguratorTest < ActiveSupport::TestCase
    test "load items from file" do
      begin
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

    test "full persist" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.integer :foo, value: 1
        c.integer :bar, value: 2
        c.integer :baz, value: 3
        assert c.persist
      end
      assert_equal 1, SystemSettings[:foo]
      assert_equal 2, SystemSettings[:bar]
    end

    test "partial persist" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.integer :foo, value: 1
        c.integer :bar, value: 2
        c.integer :baz, value: 3
        assert c.persist(only: [:foo, :baz])
      end
      assert_equal 1, SystemSettings[:foo]
      assert_raises SystemSettings::Errors::NotFoundError do
        SystemSettings[:bar]
      end
      assert_equal 3, SystemSettings[:baz]
    end

    test "partial persist with invalid name" do
      called = false
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.integer :foo, value: 1
        c.integer :bar, value: 2
        error = assert_raises SystemSettings::Errors::NotLoadedError do
          c.persist(only: [:nope])
        end
        expected_message = <<~MESSAGE.strip
          Couldn't persist system setting nope. There are no items by this name. Could it be a typo?

          Configurator has loaded following items:
          foo
          bar
        MESSAGE
        assert_equal expected_message, error.message
        called = true
      end
      assert called
    end

    test "partial load with no items" do
      called = false
      SystemSettings::Configurator.new do |c|
        assert c.purge
        error = assert_raises SystemSettings::Errors::NotLoadedError do
          c.persist(only: [:first])
        end
        expected_message = <<~MESSAGE.strip
          Couldn't persist system setting first. There are no items by this name. Could it be a typo?

          Configurator has loaded following items:
          (none)
        MESSAGE
        assert_equal expected_message, error.message
        called = true
      end
      assert called
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

    test "boolean setting" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.boolean :foo, value: false
        c.boolean :bar, value: true
        assert c.persist
      end
      assert_equal false, SystemSettings[:foo]
      assert_equal true, SystemSettings[:bar]
    end

    test "decimal setting" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.decimal :foo, value: BigDecimal("123.456")
        assert c.persist
      end
      assert_equal 123.456, SystemSettings[:foo]
    end

    test "decimal list setting" do
      SystemSettings::Configurator.new do |c|
        assert c.purge
        c.decimal_list :foo, value: []
        c.decimal_list :bar, value: [11.22, BigDecimal("46.7")]
        assert c.persist
      end
      assert_equal [], SystemSettings[:foo]
      assert_equal [11.22, 46.7], SystemSettings[:bar]
    end

    test "warn about type mismatch" do
      SystemSettings.load
      assert_equal 50, SystemSettings[:default_records_per_page]

      kernel_mock = Minitest::Mock.new
      kernel_mock.expect :warn, nil, ["SystemSettings: Type mismatch detected! Previously default_records_per_page had type SystemSettings::IntegerSetting but you are loading SystemSettings::StringSetting"]

      SystemSettings::Configurator.new(kernel_class: kernel_mock) do |c|
        c.string :default_records_per_page, value: "many"
        assert c.persist
      end

      kernel_mock.verify
      assert_equal 50, SystemSettings[:default_records_per_page]
    end

    test "warn about non-existing database" do
      assert SystemSettings::Setting.table_exists?
      kernel_mock = Minitest::Mock.new
      kernel_mock.expect :warn, nil, ["SystemSettings: Settings table has not been created!"]
      SystemSettings::Setting.stub(:table_exists?, false) do
        refute SystemSettings::Setting.table_exists?
        SystemSettings::Configurator.new(kernel_class: kernel_mock) do |c|
          c.boolean :foo, value: false
          assert_equal false, c.persist
        end
      end
      kernel_mock.verify
    end
  end
end
