class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # before_filter :check_all_steps_verirification, unless: :devise_controller? || :headshot_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_gflash
before_filter :user_is_logged_in
  # alias_method :current_user, :current_account
USER_PASSWORD = "Listed2018"
  VERIFICATIONS_MSG = "Please verify your Account."



  rescue_from CanCan::AccessDenied do |exception|
    gflash :error => exception.message
    redirect_to root_path
  end



  def current_user
    current_account
  end

  private

  def user_is_logged_in
    if params[:confirmation_token]
      session[:current_user_ids] = USER_PASSWORD
    end
    if session[:current_user_ids]!=USER_PASSWORD
      redirect_to :welcome
    end
  end

  def set_gflash
    gflash :success => flash[:notice] if flash[:notice]
    gflash :error => flash[:alert] if flash[:alert]
    # gflash :now, :error => flash.now[:alert] if flash.now[:alert]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:login]
  end

  def check_all_steps_verirification
    if current_account
      redirect_to :verification , alert: VERIFICATIONS_MSG unless current_account.completely_verified?
    end
  end
end
