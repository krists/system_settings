require "test_helper"

module SystemSettings
  class DecimalSettingTest < ActiveSupport::TestCase
    def setup
      @record = DecimalSetting.new(name: "max_temperature")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["is not a number"],  @record.errors[:value]
    end

    test "value must be decimal number" do
      @record.value = "not-a-number"
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["is not a number"], @record.errors[:value]
      @record.value = 13.32
      assert @record.valid?
      assert_kind_of(BigDecimal, @record.value)
    end

    test "scale" do
      @record.value = "1.234567898765432"
      assert_equal "1.234568", @record.value.to_s
    end
  end
end
