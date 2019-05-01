settings = SystemSettings::Configurator.from_file(File.expand_path("../../../../examples/system_settings.rb", __dir__))
# settings.purge
settings.persist
