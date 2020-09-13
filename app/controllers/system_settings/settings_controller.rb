# frozen_string_literal: true

module SystemSettings
  class SettingsController < SystemSettings::ApplicationController
    RETURN_ATTRIBUTES = %w[id name type value description].freeze
    before_action :set_setting, only: [:edit, :show, :update]

    def index
      @settings = SystemSettings::Setting.order(:name)
    end

    def edit; end

    def show; end

    def update
      if @setting.update(setting_params)
        redirect_to setting_path(@setting)
      else
        render :edit
      end
    end

    private

    def set_setting
      @setting = SystemSettings::Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit(:value)
    end
  end
end
