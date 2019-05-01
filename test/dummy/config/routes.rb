Rails.application.routes.draw do
  mount SystemSettings::Engine => "/system_settings"
end
