# frozen_string_literal: true

module SystemSettings
  class StringSetting < SystemSettings::Setting
    attribute :value, :string
    validates :value, presence: true
  end
end
