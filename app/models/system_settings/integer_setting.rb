require_relative "./setting"

module SystemSettings
  class IntegerSetting < Setting
    attribute :value, :integer
    validates :value, numericality: { only_integer: true }
  end
end
