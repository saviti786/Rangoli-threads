module Admin
  class OrdersController < Admin::BaseController
    def index
      @orders = Order.includes(:user, order_items: :product)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
    end

    def show
      @order = Order.includes(:user, order_items: :product).find(params[:id])
    end
  end
end
