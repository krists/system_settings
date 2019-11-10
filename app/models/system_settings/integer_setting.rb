# frozen_string_literal: true

module SystemSettings
  class IntegerSetting < SystemSettings::Setting
    attribute :value, :integer, limit: 8
    validates :value, numericality: { only_integer: true }
  end
end
