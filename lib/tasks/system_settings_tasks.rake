namespace :system_settings do
  desc "Load system settings from config/system_settings.rb file"
  task :load => [:environment] do
    settings_path = Rails.root.join("config", "system_settings.rb")
    settings = SystemSettings::Configurator.from_file(settings_path.to_s)
    settings.persist || exit(1)
  end

  desc "Delete all system settings"
  task :purge => [:environment] do
    SystemSettings::Configurator.purge
  end
end

