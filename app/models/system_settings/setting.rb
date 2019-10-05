# frozen_string_literal: true

module SystemSettings
  class Setting < SystemSettings::ApplicationRecord
    validates :type, presence: true
    validates :name, presence: true, uniqueness: true
  end
end
