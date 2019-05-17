namespace :system_settings do
  desc "Load system settings from SYSTEM_SETTINGS_PATH or config/system_settings.rb file"
  task :load => [:environment] do
    configurator = SystemSettings::Configurator.from_file(SystemSettings.settings_file_path)
    configurator.purge
    configurator.persist
  end

  desc "Delete all system settings"
  task :purge => [:environment] do
    SystemSettings::Configurator.purge
  end

  desc "Reset settings to values from SYSTEM_SETTINGS_PATH or config/system_settings.rb file"
  task :reset => [:environment] do
    SystemSettings.reset_to_defaults
  end
end
