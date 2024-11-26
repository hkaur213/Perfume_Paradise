class ApplicationController < ActionController::Base
  before_action :set_current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def check_admin_priv
    if !current_admin
      redirect_to root_path
    end
  end

  private
  
  def set_current_cart
    if user_signed_in?
      @current_cart = current_user.cart || Cart.create(user: current_user)
    elsif session[:current_cart_id]
      @current_cart = Cart.find_by_secret_id(session[:current_cart_id])
    else
      @current_cart = Cart.create
      session[:current_cart_id] = @current_cart.secret_id
    end
  end
  

   # Permit the new fields during sign up and account update
   def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:address, :city, :state, :province, :zip_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:address, :city, :state, :province, :zip_code])
  end
end