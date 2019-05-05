require "test_helper"

module SystemSettings
  class IntegerListSettingTest < ActiveSupport::TestCase

    def setup
      @record = IntegerListSetting.new(name: "allowed_values")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of integers"], @record.errors[:value]
    end

    test "value must be array of integers" do
      @record.value = [11.0, 12.0, 13.0]
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of integers"], @record.errors[:value]

      @record.value = [11, 12, 13]
      assert @record.valid?
    end

    test "cast from string with semicolon as delimiter" do
      @record.value = "1;2;3"
      assert @record.valid?
      assert_equal [1, 2, 3], @record.value
    end

    test "cast from string with comma as delimiter" do
      @record.value = "4,5,6"
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of integers"], @record.errors[:value]
    end

    test "cast from strings with extra whitespace" do
      @record.value = " 99 "
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of integers"], @record.errors[:value]
    end
  end
end
