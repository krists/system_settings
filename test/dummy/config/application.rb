require_relative "boot"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
Bundler.require(*Rails.groups)
require "system_settings"

module Dummy
  class Application < Rails::Application
    if config.respond_to?(:load_defaults)
      config.load_defaults [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join(".")
    else # Rails 5.0 does now have load_defaults method
      config.action_controller.raise_on_unfiltered_parameters = true
      config.action_controller.per_form_csrf_tokens = true
      config.action_controller.forgery_protection_origin_check = true
      ActiveSupport.to_time_preserves_timezone = true
      config.active_record.belongs_to_required_by_default = true
      ActiveSupport.halt_callback_chains_on_return_false = false
      config.ssl_options = { hsts: { subdomains: true } }
    end
    config.api_only = true
  end
end
