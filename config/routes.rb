# frozen_string_literal: true

SystemSettings::Engine.routes.draw do
  resources :settings, only: [:show, :edit] do
    member do
      post "/", to: "settings#update"
    end
  end
  root to: "settings#index"
end
