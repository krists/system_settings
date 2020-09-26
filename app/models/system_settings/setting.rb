# frozen_string_literal: true

class SystemSettings::Setting < SystemSettings::ApplicationRecord
  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
end
