require_relative "boot"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
Bundler.require(*Rails.groups)
require "system_settings"

module Dummy
  class Application < Rails::Application
    config.load_defaults [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join(".")
    config.session_store :cookie_store, key: "system_settings_sid_#{Rails.env}"
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :lv]
  end
end
