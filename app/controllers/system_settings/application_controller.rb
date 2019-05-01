module SystemSettings
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private

    def add_authenticity_token
      response.headers["Authenticity-Token"] = form_authenticity_token if protect_against_forgery?
    end
  end
end
