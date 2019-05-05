require_relative "./setting"

module SystemSettings
  class StringListSetting < Setting
    attribute :value, SystemSettings::Type::StringList.new
    validates :value, list_of_strings: true
  end
end
