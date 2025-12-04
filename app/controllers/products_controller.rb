class ProductsController < ApplicationController
  before_action :load_categories, only: %i[index search on_sale new_arrivals recently_updated]

  def index
    @products = base_products.order(created_at: :desc)
                             .page(params[:page])
                             .per(12)
  end

  def show
    @product = Product.find(params[:id])
    @related_products = @product.category.products
                                .where.not(id: @product.id)
                                .limit(4)
  end

  def search
    @query = params[:query]
    @category_id = params[:category_id]

    @products = filtered_products.order(created_at: :desc)
                                 .page(params[:page])
                                 .per(12)

    render :index
  end

  def on_sale
    @products = base_products.where(on_sale: true)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(12)

    @filter_title = "Products On Sale"
    render :index
  end

  def new_arrivals
    @products = base_products.where(new_arrival: true)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(12)

    @filter_title = "New Arrivals"
    render :index
  end

  def recently_updated
    three_days_ago = 3.days.ago

    @products = base_products.where(
      "updated_at >= ? AND created_at < ?",
      three_days_ago, three_days_ago
    ).order(updated_at: :desc)
                             .page(params[:page])
                             .per(12)

    @filter_title = "Recently Updated"
    render :index
  end

  private

  # Shared product base query
  def base_products
    Product.includes(:category)
  end

  # Apply filters for search
  def filtered_products
    products = base_products
    products = products.where("name LIKE :q OR description LIKE :q", q: "%#{@query}%") if @query.present?
    products = products.where(category_id: @category_id) if @category_id.present? && @category_id != ""
    products
  end

  def load_categories
    @categories = Category.all
  end
end
