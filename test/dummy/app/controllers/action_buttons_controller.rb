class ActionButtonsController < ApplicationController
  def index
    render plain: SystemSettings[:non_existing]
  end
end
