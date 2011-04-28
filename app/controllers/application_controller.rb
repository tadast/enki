# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  after_filter :set_content_type
  before_filter :log_referer

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery :secret => 'a6a9e417376364b61645d469f04ac8cf'

  protected

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def config
    @@config = Enki::Config.default
  end

  def rescue_action_in_public(exception)
    if exception.is_a?ActiveRecord::RecordNotFound
      render :partial => 'posts/error_404', :layout => 'application', :status => 404
    else
      super
    end
  end

  helper_method :config

  def log_referer
    logger.info "Referer: #{request.referer}" if request.referer
    true
  end

  def prepare_hidden_styles
    # normal styles
    @ns = 20.times.map{ "hs#{rand(10000)}" }.uniq.shuffle

    # hidden styles
    @hs = @ns.shift(@ns.size/2)

    def @ns.random; self[ Kernel.rand(size) ]; end
    def @hs.random; self[ Kernel.rand(size) ]; end

    @styles = []
    @ns.each{ |s| @styles << ".#{s} {}" }
    @hs.each{ |s| @styles << ".#{s} {display:none}" }
    @styles.shuffle!
    true
  end
end
