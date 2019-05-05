require_relative "./setting"

module SystemSettings
  class StringSetting < Setting
    attribute :value, :string
    validates :value, presence: true
  end
end
