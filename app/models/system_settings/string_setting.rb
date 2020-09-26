# frozen_string_literal: true

class SystemSettings::StringSetting < SystemSettings::Setting
  attribute :value, :string
  validates :value, presence: true

  def value=(original_value)
    next_value = original_value.to_s.blank? ? nil : original_value.to_s.strip
    super(next_value)
  end
end
