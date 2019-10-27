# frozen_string_literal: true

require "system_settings/engine"

module SystemSettings
  class << self
    attr_accessor :settings_file_path, :instrumenter
  end

  def self.[](name)
    instrument("system_settings.find", name: name) do |payload|
      record = Setting.find_by(name: name)
      unless record
        message = <<~MESSAGE.strip
          Couldn't find system setting #{name}

          It might not be loaded from settings file(#{settings_file_path}).
          To load missing settings with their initial values you can call SystemSettings.load from your Rails environment or run Rails task:

              bin/rails system_settings:load RAILS_ENV=#{::Rails.env}
        MESSAGE
        raise(Errors::NotFoundError, message)
      end
      payload[:value] = record.value
    end
  end

  def self.load(*names)
    instrument("system_settings.load", path: settings_file_path) do |payload|
      configurator = Configurator.from_file(settings_file_path)
      payload[:success] = configurator.persist(only: names)
    end
  end

  def self.reset_to_defaults
    instrument("system_settings.reset_to_defaults", path: settings_file_path) do |payload|
      configurator = Configurator.from_file(settings_file_path)
      Setting.transaction do
        payload[:success] = configurator.purge && configurator.persist
      end
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
