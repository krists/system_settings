# frozen_string_literal: true

module SystemSettings
  class Engine < ::Rails::Engine
    class << self
      def frontend_build_path
        File.join(root, "frontend", "build")
      end

      def frontend_build_index_html_path
        File.join(frontend_build_path, "index.html")
      end
    end

    isolate_namespace SystemSettings
    config.generators.api_only = true
    config.middleware.use ActionDispatch::Static, frontend_build_path
    config.after_initialize do
      SystemSettings.instrumenter = ActiveSupport::Notifications
      SystemSettings.settings_file_path = ENV.fetch("SYSTEM_SETTINGS_PATH") do
        Rails.root.join("config", "system_settings.rb")
      end
    end
  end
end
