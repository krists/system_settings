# frozen_string_literal: true

module SystemSettings
  class DecimalSetting < SystemSettings::Setting
    attribute :value, :decimal, scale: 6
    validates :value, numericality: true
  end
end
