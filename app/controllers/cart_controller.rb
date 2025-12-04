class CartController < ApplicationController
  include CartHelper

  def show
    @cart_items = cart_items
    @cart_total = cart_total
  end

  def add
    product = find_product
    return redirect_to products_path, alert: "Product not found." unless product

    quantity = sanitize_quantity(params[:quantity])

    if exceeds_stock?(product, quantity)
      return redirect_to product_path(product),
                         alert: "Sorry, only #{product.stock} items available in stock."
    end

    initialize_cart
    add_to_cart(product, quantity)

    redirect_to cart_path, notice: "#{product.name} added to cart!"
  end

  def update
    product_id = params[:id]
    quantity = params[:quantity].to_i

    if quantity <= 0
      remove_item(product_id)
      redirect_to cart_path, notice: "Item removed from cart."
    else
      update_item_quantity(product_id, quantity)
    end
  end

  def remove
    remove_item(params[:id])
    redirect_to cart_path, notice: "Item removed from cart."
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared."
  end

  private

  def find_product
    Product.find_by(id: params[:id])
  end

  def sanitize_quantity(qty_param)
    qty = qty_param.to_i
    qty < 1 ? 1 : qty
  end

  def initialize_cart
    session[:cart] ||= {}
  end

  def exceeds_stock?(product, quantity)
    current_quantity = session[:cart]&.[](product.id.to_s) || 0
    (current_quantity + quantity) > product.stock
  end

  def add_to_cart(product, quantity)
    product_id = product.id.to_s
    session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity
  end

  def update_item_quantity(product_id, quantity)
    product = Product.find_by(id: product_id)
    if product && quantity > product.stock
      redirect_to cart_path, alert: "Only #{product.stock} items available in stock."
    else
      session[:cart][product_id] = quantity
      redirect_to cart_path, notice: "Cart updated."
    end
  end

  def remove_item(product_id)
    session[:cart].delete(product_id)
  end
end
