require_relative "./application_controller"

module SystemSettings
  class RootController < ApplicationController
    def index
      if File.exist?(SystemSettings::Engine.frontend_build_index_html_path)
        render file: SystemSettings::Engine.frontend_build_index_html_path
      else
        render plain: "Frontend application has not been compiled", status: :not_implemented
      end
    end
  end
end
