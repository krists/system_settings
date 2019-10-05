# frozen_string_literal: true

SystemSettings::Engine.routes.draw do
  scope "api" do
    resources "settings"
  end
  root to: "root#index"
  get "*rest", to: "root#index", as: :catch_all
end
