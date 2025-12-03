class CheckoutController < ApplicationController
  include CartHelper
  before_action :authenticate_user!
  before_action :check_cart_not_empty

  def new
  @cart_items = cart_items
  @cart_total = cart_total

  # Pre-fill user address if available
  @user = current_user
  @provinces = Province.all

  # Calculate taxes if province is set
  if @user.province_id.present?
    province = @user.province
    @gst = (@cart_total * province.gst / 100).round(2)
    @pst = (@cart_total * province.pst / 100).round(2)
    @hst = (@cart_total * province.hst / 100).round(2)
    @total = @cart_total + @gst + @pst + @hst
  else
    @gst = 0
    @pst = 0
    @hst = 0
    @total = @cart_total
  end
  end

  def create
    # Update user address if provided
    if params[:user].present?
      current_user.update(user_address_params)
    end

    # Check if user has province selected
    unless current_user.province_id.present?
      redirect_to new_checkout_path, alert: "Please select your province to calculate taxes."
      return
    end

    # Get province for tax calculation
    province = current_user.province

    # Calculate totals
    subtotal = cart_total
    gst = (subtotal * province.gst / 100).round(2)
    pst = (subtotal * province.pst / 100).round(2)
    hst = (subtotal * province.hst / 100).round(2)
    total = subtotal + gst + pst + hst

    # Create order
    @order = current_user.orders.build(
      total_amount: total,
      status: "pending",
      gst_rate: province.gst,
      pst_rate: province.pst,
      hst_rate: province.hst,

      # store snapshot of delivery address
      street: current_user.street,
      city: current_user.city,
      postal_code: current_user.postal_code,
      province_name: current_user.province.name
    )

    # Create order items
    cart_items.each do |item|
      @order.order_items.build(
        product_id: item[:product].id,
        quantity: item[:quantity],
        purchase_price: item[:product].price
      )
    end

    if @order.save
      # Clear cart
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed successfully! Order ##{@order.id}"
    else
      redirect_to new_checkout_path, alert: "Failed to create order. Please try again."
    end
  end

  private

  def check_cart_not_empty
    if cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def user_address_params
    params.require(:user).permit(:street, :city, :postal_code, :province_id)
  end
end
