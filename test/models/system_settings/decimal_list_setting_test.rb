require "test_helper"

module SystemSettings
  class DecimalListSettingTest < ActiveSupport::TestCase
    def setup
      @record = DecimalListSetting.new(name: "allowed_values")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of decimals"], @record.errors[:value]
    end

    test "value must be array of decimals" do
      @record.value = ["foo", "bar", 123.45]
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of decimals"], @record.errors[:value]

      @record.value = [11.22, 12.33, 13.44]
      assert @record.valid?
    end

    test "cast from string with semicolon as delimiter" do
      @record.value = "1.8;2.1;3"
      assert @record.valid?
      assert_equal [1.8, 2.1, 3.0], @record.value
    end

    test "cast from string with comma as delimiter" do
      @record.value = "4,5"
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of decimals"], @record.errors[:value]
    end

    test "cast from strings with extra whitespace" do
      @record.value = " 99.123 "
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["not a list of decimals"], @record.errors[:value]
    end

    test "scale" do
      @record.value = "1.234567898765432"
      assert_equal "1.234568", @record.value[0].to_s
    end
  end
end
