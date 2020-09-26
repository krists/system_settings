# frozen_string_literal: true

module SystemSettings
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    ActiveSupport.run_load_hooks(:system_settings_application_controller, self)
  end
end
