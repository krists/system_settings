ActiveSupport.on_load(:system_settings_application_controller) do
  include LocaleFromParams
end
