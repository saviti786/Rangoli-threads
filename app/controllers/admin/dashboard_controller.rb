class Admin::DashboardController < Admin::BaseController
  def index
    @product_count = Product.count if defined?(Product)
  end
end
