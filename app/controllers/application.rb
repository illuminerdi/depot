# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "store"
  
  before_filter :set_locale
  before_filter :authorize, :except => :login
  
  session :session_key => '_illuminerdi_books_session_id'
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '7015e5473e32f0e7c900fe42076d02b7'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
    
  protected 
  
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
    
    locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale}.yml"
    
    unless I18n.load_path.include? locale_path 
      I18n.load_path << locale_path 
      I18n.backend.send(:init_translations) 
    end 
  
  rescue Exception => err 
    logger.error err 
    flash.now[:notice] = "#{I18n.locale} translation not available" 
    I18n.load_path -= [locale_path] 
    I18n.locale = session[:locale] = I18n.default_locale 
  end
  
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => :admin, :action => :login
    end
  end
end
