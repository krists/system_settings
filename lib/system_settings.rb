require "system_settings/engine"

module SystemSettings
  @@settings_file_path = nil

  def self.settings_file_path
    @@settings_file_path
  end

  def self.settings_file_path=(value)
    @@settings_file_path = value
  end

  def self.[](name)
    Setting.find_by!(name: name).value
  end

  def self.load
    configurator = Configurator.from_file(settings_file_path)
    configurator.persist
  end

  def self.reset_to_defaults
    configurator = Configurator.from_file(settings_file_path)
    configurator.purge
    configurator.persist
  end
end
