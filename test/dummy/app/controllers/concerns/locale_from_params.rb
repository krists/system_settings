module LocaleFromParams
  extend ActiveSupport::Concern

  included do
    around_action :setup_locale
  end

  private

  def setup_locale(&blk)
    session[:locale] = params[:locale].presence if params[:locale].present?
    locale = session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &blk)
  end
end