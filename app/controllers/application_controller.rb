class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :current_rol
  helper_method :current_person
  helper_method :lista_roles

  rescue_from ActionView::MissingTemplate, :with => :template_not_found

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def current_person
    @current_person = Persona.joins(:users).where(:personas_roles_users => {:role_id => ['2','1'], :user_id => current_user}).first
  end
  def current_rol
    @current_rol = Role.joins(:users).where(:personas_roles_users => {:user_id => current_user, :persona_id => current_person})
  end
  def lista_roles
    @lista_roles = Role.all
  end
  def template_not_found
    redirect_to denegado_path
  end

  before_filter :set_no_cache

  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
