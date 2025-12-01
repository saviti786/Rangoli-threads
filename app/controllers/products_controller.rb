class ProductsController < ApplicationController
  def index
    @products = Product.includes(:category).order(created_at: :desc).page(params[:page]).per(12)
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
    @related_products = @product.category.products.where.not(id: @product.id).limit(4)
  end

  def search
    @query = params[:query]
    @category_id = params[:category_id]
    @categories = Category.all

    @products = Product.includes(:category)

    # Filter by keyword if present
    if @query.present?
      @products = @products.where(
        "name LIKE :query OR description LIKE :query",
        query: "%#{@query}%"
      )
    end

    # Filter by category if selected (and not "All Categories")
    if @category_id.present? && @category_id != ""
      @products = @products.where(category_id: @category_id)
    end

    @products = @products.order(created_at: :desc).page(params[:page]).per(12)

    render :index
  end

  def on_sale
    @products = Product.includes(:category)
                      .where(on_sale: true)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(12)
    @categories = Category.all
    @filter_title = "Products On Sale"
    render :index
  end

 def new_arrivals
  # three_days_ago = 3.days.ago
  @products = Product.includes(:category)
                    .where(new_arrival: true)  # Changed this line
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(12)
  @categories = Category.all
  @filter_title = "New Arrivals"
  render :index
 end

  def recently_updated
    three_days_ago = 3.days.ago
    @products = Product.includes(:category)
                      .where("updated_at >= ? AND created_at < ?", three_days_ago, three_days_ago)
                      .order(updated_at: :desc)
                      .page(params[:page])
                      .per(12)
    @categories = Category.all
    @filter_title = "Recently Updated"
    render :index
  end
end
