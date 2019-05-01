require_relative "./setting"

module SystemSettings
  class StringListSetting < Setting
    attribute :value, SystemSettings::Type::StringList.new
  end
end