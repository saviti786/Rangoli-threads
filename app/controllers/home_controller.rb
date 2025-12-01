class HomeController < ApplicationController
  def index
    @categories = Category.all
    @on_sale_products = Product.where(on_sale: true).limit(8)
    @new_arrivals = Product.where("created_at >= ?", 3.days.ago).limit(8)
  end
end
