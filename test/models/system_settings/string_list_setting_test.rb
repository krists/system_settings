require "test_helper"

module SystemSettings
  class StringListSettingTest < ActiveSupport::TestCase
    def setup
      @record = StringListSetting.new(name: "foo")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of strings"], @record.errors[:value]
      assert_nil @record.value
    end

    test "value without delimiter" do
      @record.value = "foobar"
      assert @record.valid?
      assert_equal ["foobar"], @record.value
    end

    test "set value with strings separated by semicolons" do
      @record.value = "foo;bar;baz"
      assert @record.valid?
      assert_equal ["foo", "bar", "baz"], @record.value
    end

    test "set value with separator escaped" do
      @record.value = "foo\\;bar;baz"
      assert @record.valid?
      assert_equal ["foo\\;bar", "baz"], @record.value
    end

    test "set value with array" do
      @record.value = ["123", 456]
      assert @record.valid?
      assert_equal ["123", "456"], @record.value
    end
  end
end
