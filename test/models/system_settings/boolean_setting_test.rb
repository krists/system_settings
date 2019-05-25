require "test_helper"

module SystemSettings
  class BooleanSettingTest < ActiveSupport::TestCase
    def setup
      @record = BooleanSetting.new(name: "enable_user_import")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["must be set to true or false"],  @record.errors[:value]
    end

    test "value cast from TrueClass" do
      @record.value = true
      assert @record.valid?
      assert_equal true, @record.value
    end

    test "value cast from FalseClass" do
      @record.value = false
      assert @record.valid?
      assert_equal false, @record.value
    end

    test "value cast from 1 string" do
      @record.value = "1"
      assert @record.valid?
      assert_equal true, @record.value
    end

    test "value cast from 0 string" do
      @record.value = "0"
      assert @record.valid?
      assert_equal false, @record.value
    end

    test "value cast from 'true' string" do
      @record.value = "true"
      assert @record.valid?
      assert_equal true, @record.value
    end

    test "value cast from 'false' string" do
      @record.value = "false"
      assert @record.valid?
      assert_equal false, @record.value
    end
  end
end
