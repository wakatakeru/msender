class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :is_login
  
  def current_user
    return unless session[:login_id]
    @current_user = User.find_by(:id => session[:login_id])
  end

  def is_login
    !!session[:login_id]
  end
end
