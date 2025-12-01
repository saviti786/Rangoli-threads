class CartController < ApplicationController
  include CartHelper

  def show
    @cart_items = cart_items
    @cart_total = cart_total
  end

  def add
    product = Product.find(params[:id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    # Check if product has enough stock
    if product.stock < quantity
      redirect_to product_path(product), alert: "Sorry, only #{product.stock} items available in stock."
      return
    end

    # Initialize cart if not exists
    session[:cart] ||= {}

    # Add or update quantity
    if session[:cart][product.id.to_s]
      new_quantity = session[:cart][product.id.to_s] + quantity
      if new_quantity > product.stock
        redirect_to product_path(product), alert: "Cannot add more items. Only #{product.stock} available."
        return
      end
      session[:cart][product.id.to_s] = new_quantity
    else
      session[:cart][product.id.to_s] = quantity
    end

    redirect_to cart_path, notice: "#{product.name} added to cart!"
  end

  def update
    product_id = params[:id]
    quantity = params[:quantity].to_i

    if quantity <= 0
      session[:cart].delete(product_id)
      redirect_to cart_path, notice: "Item removed from cart."
    else
      product = Product.find_by(id: product_id)

      if product && quantity > product.stock
        redirect_to cart_path, alert: "Only #{product.stock} items available in stock."
      else
        session[:cart][product_id] = quantity
        redirect_to cart_path, notice: "Cart updated."
      end
    end
  end

  def remove
    product_id = params[:id]
    product = Product.find_by(id: product_id)
    product_name = product&.name || "Item"

    session[:cart].delete(product_id)

    redirect_to cart_path, notice: "#{product_name} removed from cart."
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared."
  end
end
