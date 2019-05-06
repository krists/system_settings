require "test_helper"

module SystemSettings
  class IntegerSettingTest < ActiveSupport::TestCase
    def setup
      @record = IntegerSetting.new(name: "max_retries")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["is not a number"],  @record.errors[:value]
    end

    test "value must be integer" do
      @record.value = "twelve"
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_equal ["is not a number"], @record.errors[:value]

      @record.value = 13
      assert @record.valid?
    end
  end
end
