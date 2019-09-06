module SystemSettings
  class StringListSetting < SystemSettings::Setting
    attribute :value, SystemSettings::Type::StringList.new
    validates :value, "system_settings/list_of_strings": true
  end
end
