# frozen_string_literal: true

class SystemSettings::BooleanSetting < SystemSettings::Setting
  attribute :value, :boolean
  validates :value, inclusion: [true, false]
end
