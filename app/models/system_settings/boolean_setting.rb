# frozen_string_literal: true

module SystemSettings
  class BooleanSetting < SystemSettings::Setting
    attribute :value, :boolean
    validates :value, inclusion: [true, false]
  end
end
