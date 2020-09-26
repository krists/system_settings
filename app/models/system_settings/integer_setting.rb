# frozen_string_literal: true

class SystemSettings::IntegerSetting < SystemSettings::Setting
  attribute :value, :integer, limit: 8
  validates :value, numericality: { only_integer: true }
end
