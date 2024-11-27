class ProfilesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in if you're using Devise

  def show
    @user = current_user
    @orders = @user.orders.includes(:order_items) # Preload associated items to prevent N+1 queries
  end
end
