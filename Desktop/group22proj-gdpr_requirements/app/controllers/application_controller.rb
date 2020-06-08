class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

    devise_parameter_sanitizer.permit(:sign_up, keys: [:is_student])
    devise_parameter_sanitizer.permit(:account_update, keys: [:is_student])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_rating])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_rating])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:admin])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:student_email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:student_email])
  end

  private

  def current_yt_user
    @current_yt_user ||= YtUser.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_yt_user
end

