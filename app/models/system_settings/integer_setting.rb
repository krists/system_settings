module SystemSettings
  class IntegerSetting < SystemSettings::Setting
    attribute :value, :integer
    validates :value, numericality: { only_integer: true }
  end
end
