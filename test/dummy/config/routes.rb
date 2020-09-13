Rails.application.routes.draw do
  mount SystemSettings::Engine => "/system_settings"
  root to: redirect("/system_settings")
end
