require "system_settings/engine"

module SystemSettings
  class << self
    attr_accessor :settings_file_path
  end

  def self.[](name)
    record = Setting.find_by(name: name) || raise(Errors::NotFoundError, "Couldn't find system setting #{name}")
    record.value
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
