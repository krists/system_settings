# frozen_string_literal: true

module SystemSettings::Errors
  class NotFoundError < SystemSettings::Errors::Error
    if ActiveSupport.const_defined?("ActionableError")
      include ActiveSupport::ActionableError

      action "Load all settings" do
        SystemSettings.load
      end
    end
  end
end
