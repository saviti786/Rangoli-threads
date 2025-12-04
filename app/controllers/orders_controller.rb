class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    # Use safe finding to ensure only owned orders are shown
    @order = current_user.orders.find(params[:id])
  end

  private

  # Permits user fields (address and name) for saving during checkout
  def user_params
    params.require(:user).permit(:name, :street, :city, :postal_code, :province_id)
  end

  # Permits order-specific fields (you will need to complete this)
  def order_params
    params.require(:order).permit(
      :total_amount, :gst_rate, :pst_rate, :hst_rate,
      :street, :city, :postal_code, :province_name
    )
  end
end
