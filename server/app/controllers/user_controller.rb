class UserController < ApplicationController
  before_action :set_user, only: [:show]

  def show

  end

  def new
    p = user_params
    user = User.new do |u|
      u.picture = p.picture
      u.first_name = p.first_name
      u.last_name = p.last_name
      u.phone = p.phone
    end
    if user.save
      render :user_creation_success
    else
      render :user_creation_failure

  end

  private
    def user_params
      params.permit(:picture, :first_name, :last_name, :phone)
    end

    def set_user
        up = user_params
        @user = User.find(up[:user_id])
    end
end
