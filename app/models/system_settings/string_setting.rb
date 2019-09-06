module SystemSettings
  class StringSetting < SystemSettings::Setting
    attribute :value, :string
    validates :value, presence: true
  end
end
