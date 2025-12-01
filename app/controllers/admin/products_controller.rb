class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all
  end

  def show
    redirect_to admin_products_path
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      @categories = Category.all
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Product was successfully updated."
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product was successfully destroyed."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, :image, :on_sale, :new_arrival)
  end
end
