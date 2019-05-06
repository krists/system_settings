require_relative "./setting"

module SystemSettings
  class IntegerListSetting < Setting
    attribute :value, SystemSettings::Type::IntegerList.new
    validates :value, "system_settings/list_of_integers": true
  end
end
