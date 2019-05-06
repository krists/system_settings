require_relative "boot"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie" # TODO: WHY?
Bundler.require(*Rails.groups)
require "system_settings"

module Dummy
  class Application < Rails::Application
    if config.respond_to?(:load_defaults)
      loaded_rails_version = Bundler.locked_gems.dependencies["rails"].to_spec.version
      config.load_defaults loaded_rails_version.segments[0...2].join(".")
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
