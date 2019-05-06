class DashboardController < ApplicationController
  def index
    render json: {app: "Dummy"}
  end
end
