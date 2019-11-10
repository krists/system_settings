# frozen_string_literal: true

module SystemSettings
  class IntegerListSetting < SystemSettings::Setting
    attribute :value, SystemSettings::Type::IntegerList.new(limit: 8)
    validates :value, "system_settings/list_of_integers": true
  end
end
