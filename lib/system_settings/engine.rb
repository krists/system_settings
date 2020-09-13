# frozen_string_literal: true

module SystemSettings
  class Engine < ::Rails::Engine
    isolate_namespace SystemSettings
    initializer "system_settings.assets.precompile" do |app|
      app.config.assets.precompile += %w[system_settings/application.css] if app.config.respond_to?(:assets)
    end
    config.after_initialize do
      SystemSettings.instrumenter = ActiveSupport::Notifications
      SystemSettings.settings_file_path = ENV.fetch("SYSTEM_SETTINGS_PATH") do
        Rails.root.join("config", "system_settings.rb").to_s
      end
    end
  end
end
