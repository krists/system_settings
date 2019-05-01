require_relative "./application_record"

module SystemSettings
  class Setting < ApplicationRecord
    validates :type, presence: true
    validates :name, presence: true, uniqueness: true
  end
end