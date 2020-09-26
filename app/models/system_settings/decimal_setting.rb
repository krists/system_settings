# frozen_string_literal: true

class SystemSettings::DecimalSetting < SystemSettings::Setting
  attribute :value, :decimal, scale: 6
  validates :value, numericality: true
end
