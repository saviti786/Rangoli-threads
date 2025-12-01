module CartHelper
  def current_cart
    @current_cart ||= begin
      if session[:cart].present?
        session[:cart]
      else
        session[:cart] = {}
      end
    end
  end

  def cart_count
    current_cart.values.sum
  end

  def cart_total
    total = 0
    current_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      total += (product.price * quantity) if product
    end
    total
  end

  def cart_items
    items = []
    current_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        items << {
          product: product,
          quantity: quantity,
          subtotal: product.price * quantity
        }
      end
    end
    items
  end
end
