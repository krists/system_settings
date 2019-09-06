module SystemSettings
  class BooleanSetting < SystemSettings::Setting
    attribute :value, :boolean
    validates :value, inclusion: [true, false]
  end
end
