# frozen_string_literal: true

module SystemSettings
  class DecimalListSetting < SystemSettings::Setting
    attribute :value, SystemSettings::Type::DecimalList.new(scale: 6)
    validates :value, "system_settings/list_of_decimals": true
  end
end
