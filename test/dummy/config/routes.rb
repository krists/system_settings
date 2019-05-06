Rails.application.routes.draw do
  mount SystemSettings::Engine => "/system_settings"
  root to: "dashboard#index"
end
