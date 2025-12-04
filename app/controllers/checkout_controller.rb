class CheckoutController < ApplicationController
  include CartHelper
  before_action :authenticate_user!
  before_action :check_cart_not_empty

  def new
    @cart_items = cart_items
    @cart_total = cart_total
    @user = current_user
    @provinces = Province.all

    calculate_taxes_for(@user.province)
  end

  def create
    update_user_address if params[:user].present?
    return if redirect_if_no_province

    @order = build_order_for(current_user.province)
    build_order_items(@order)

    process_order(@order)
  end

  private

  # ----------------------------------
  # Callbacks
  # ----------------------------------
  def check_cart_not_empty
    return unless cart_items.empty?

    redirect_to cart_path, alert: "Your cart is empty."
  end

  # ----------------------------------
  # User address
  # ----------------------------------
  def update_user_address
    current_user.update(user_address_params)
  end

  def user_address_params
    params.require(:user).permit(:street, :city, :postal_code, :province_id)
  end

  # ----------------------------------
  # Taxes
  # ----------------------------------
  def calculate_taxes_for(province)
    subtotal = cart_total
    if province.present?
      @gst, @pst, @hst = tax_amounts(subtotal, province)
      @total = subtotal + @gst + @pst + @hst
    else
      @gst = @pst = @hst = 0
      @total = subtotal
    end
  end

  def tax_amounts(subtotal, province)
    [
      (subtotal * province.gst / 100).round(2),
      (subtotal * province.pst / 100).round(2),
      (subtotal * province.hst / 100).round(2)
    ]
  end

  # ----------------------------------
  # Order creation
  # ----------------------------------
  def redirect_if_no_province
    return false if current_user.province.present?

    redirect_to new_checkout_path, alert: "Please select your province to calculate taxes."
    true
  end

  def build_order_for(province)
    current_user.orders.build(total_amount: total_with_taxes(province),
                              status:       "pending",
                              gst_rate:     province.gst,
                              pst_rate:     province.pst,
                              hst_rate:     province.hst).tap do |order|
      attach_user_address(order)
    end
  end

  def total_with_taxes(province)
    subtotal = cart_total
    gst, pst, hst = tax_amounts(subtotal, province)
    @gst = gst
    @pst = pst
    @hst = hst
    subtotal + gst + pst + hst
  end

  def attach_user_address(order)
    order.street        = current_user.street
    order.city          = current_user.city
    order.postal_code   = current_user.postal_code
    order.province_name = current_user.province.name
  end

  def build_order_items(order)
    cart_items.each do |item|
      order.order_items.build(
        product_id:     item[:product].id,
        quantity:       item[:quantity],
        purchase_price: item[:product].price
      )
    end
  end

  def process_order(order)
    if order.save
      clear_cart
      redirect_to order_path(order), notice: "Order placed successfully! Order ##{order.id}"
    else
      redirect_to new_checkout_path, alert: "Failed to create order. Please try again."
    end
  end

  # ----------------------------------
  # Cart
  # ----------------------------------
  def clear_cart
    session[:cart] = {}
  end
end
