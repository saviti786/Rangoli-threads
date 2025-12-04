class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit_profile
    @user = current_user
    @provinces = Province.all
  end

  def update_profile
    @user = current_user

    if @user.update(user_profile_params)
      redirect_to edit_profile_path, notice: "Profile updated successfully."
    else
      @provinces = Province.all
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(:name, :street, :city, :postal_code, :province_id)
  end
end
