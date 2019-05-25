require_relative "./setting"

module SystemSettings
  class BooleanSetting < Setting
    attribute :value, :boolean
    validates :value, inclusion: [true, false]
  end
end
