module Admin
  class DashboardController < Admin::BaseController
    def index
      @total_products = Product.count
      @total_categories = Category.count
      @on_sale_products = Product.where(on_sale: true).count
      @new_arrivals = Product.where(new_arrival: true).count
      @low_stock_products = Product.where("stock < ?", 10).count
      @recent_products = Product.order(created_at: :desc).limit(5)
    end
  end
end
