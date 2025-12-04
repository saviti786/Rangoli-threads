module CartHelper
  def current_cart
    session[:cart] ||= {}
  end

  def cart_count
    current_cart.values.sum
  end

  def cart_total
    current_cart.sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? product.price * quantity : 0
    end
  end

  def cart_items
    current_cart.filter_map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      {
        product:  product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
    end
  end
end
