# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all # include all helpers, all the time

  after_filter :set_content_type
  before_filter :log_referer

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery :secret => 'a6a9e417376364b61645d469f04ac8cf'

  rescue_from ActiveRecord::RecordNotFound do |ex|
    render 'posts/_error_404', :status => 404
  end

  protected

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

  def enki_config
    @@enki_config = Enki::Config.default
  end

  helper_method :enki_config

  def log_referer
    Rails.logger.info "Referer: #{request.referer}" if request.referer
    true
  end

  def prepare_hidden_styles
    # normal styles
    @ns = 20.times.map{ "hs#{rand(10000)}" }.uniq.shuffle

    # hidden styles
    @hs = @ns.shift(@ns.size/2)

    @styles = []
    @ns.each{ |s| @styles << ".#{s} {}" }
    @hs.each{ |s| @styles << ".#{s} {display:none}" }
    @styles.shuffle!
    true
  end
end
