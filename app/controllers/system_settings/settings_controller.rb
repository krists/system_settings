module SystemSettings
  class SettingsController < SystemSettings::ApplicationController
    RETURN_ATTRIBUTES = ["id", "name", "type", "value", "description"].freeze

    def index
      @total_count = SystemSettings::Setting.count
      @settings = SystemSettings::Setting.order(:name).extending(SystemSettings::Pagination).page(params[:page], per_page: params[:per])
      render json: {
          items: @settings.map { |s| s.as_json(only: RETURN_ATTRIBUTES) },
          total_count: @total_count
      }
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
