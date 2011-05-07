class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :require_login
  skip_after_filter :add_google_analytics_code
  skip_after_filter :add_yandex_metrika_code

  protected

  def require_login
    return redirect_to(admin_session_path) unless session[:logged_in] || Rails.env == 'test'
  end

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end
end
