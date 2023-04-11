Rails.application.routes.draw do
  mount SystemSettings::Engine => "/system_settings"
  get "action_button", to: "action_buttons#index"
  get "favicon.ico" => lambda { |_| [204, {}, []] }
  root to: redirect("/system_settings")
end
