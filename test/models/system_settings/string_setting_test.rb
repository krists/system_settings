require "test_helper"

module SystemSettings
  class StringSettingTest < ActiveSupport::TestCase
    def setup
      @record = StringSetting.new(name: "foo")
    end

    test "value must be present" do
      @record.value = nil
      refute @record.valid?
      assert @record.errors.include?(:value)
      assert_match /can'|’t be blank/, @record.errors[:value].first
    end

    test "value cast from non-string" do
      @record.value = 989
      assert @record.valid?
      assert_equal "989", @record.value
    end
  end
end
