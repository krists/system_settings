module SystemSettings
  class IntegerListSetting < SystemSettings::Setting
    attribute :value, SystemSettings::Type::IntegerList.new
    validates :value, "system_settings/list_of_integers": true
  end
end
