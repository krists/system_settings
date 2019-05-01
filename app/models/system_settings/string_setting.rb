require_relative "./setting"

module SystemSettings
  class StringSetting < Setting
    attribute :value, :string
  end
end
