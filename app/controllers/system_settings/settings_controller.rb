require_relative "./application_controller"

module SystemSettings
  class SettingsController < ApplicationController
    RETURN_ATTRIBUTES = ["id", "name", "type", "value", "description"].freeze

    def index
      @settings = SystemSettings::Setting.order(:name)
      render json: @settings.map { |s| s.as_json(only: RETURN_ATTRIBUTES) }
    end

    def show
      @setting = SystemSettings::Setting.find(params[:id])
      add_authenticity_token
      render json: @setting.as_json(only: RETURN_ATTRIBUTES)
    end

    def update
      @setting = SystemSettings::Setting.find(params[:id])
      if @setting.update(value: params[:value])
        render json: @setting.as_json(only: RETURN_ATTRIBUTES)
      else
        render json: {errors: @setting.errors.as_json}, status: :unprocessable_entity
      end
    end
  end
end
