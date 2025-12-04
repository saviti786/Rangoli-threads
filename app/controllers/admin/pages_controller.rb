module Admin
  class PagesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_page, only: %i[edit update]

    def edit
      # @page is set by before_action
    end

    def update
      if @page.update(page_params)
        redirect_to edit_admin_page_path(@page), notice: "Page was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :content)
    end

    def require_admin
      return if current_user&.admin?

      redirect_to root_path, alert: "Access denied."
    end
  end
end
