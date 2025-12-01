class ApplicationController < ActionController::Base
  include CartHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart, :cart_count, :cart_total, :cart_items

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
