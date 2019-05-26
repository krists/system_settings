require "system_settings/engine"

module SystemSettings
  class << self
    attr_accessor :settings_file_path, :instrumenter
  end

  def self.[](name)
    instrument("system_settings.find", name: name) do |payload|
      record = Setting.find_by(name: name) || raise(Errors::NotFoundError, "Couldn't find system setting #{name}")
      payload[:value] = record.value
    end
  end

  def self.load
    instrument("system_settings.load", path: settings_file_path) do |payload|
      configurator = Configurator.from_file(settings_file_path)
      payload[:success] = configurator.persist
    end
  end

  def self.reset_to_defaults
    instrument("system_settings.reset_to_defaults", path: settings_file_path) do |payload|
      configurator = Configurator.from_file(settings_file_path)
      payload[:success] = configurator.purge && configurator.persist
    end
  end

  def self.instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      yield(payload)
    end
  end
end
