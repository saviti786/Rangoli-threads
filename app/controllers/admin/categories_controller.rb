module Admin
  class CategoriesController < Admin::BaseController
    before_action :set_category, only: %i[show edit update destroy]

    def index
      @categories = Category.all
    end

    def show
      redirect_to admin_categories_path
    end

    def new
      @category = Category.new
    end

    def edit; end

    # def destroy
    # if @category.products.any?
    #   redirect_to admin_categories_path, alert: "Cannot delete category with existing products. Please reassign or delete the products first."
    # else
    #   @category.destroy
    #   redirect_to admin_categories_path, notice: "Category was successfully destroyed."
    # end
    # end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Category was successfully destroyed."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end
  end
end
