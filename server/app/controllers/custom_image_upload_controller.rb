class CustomImageUploadController < ApplicationController
    before_action :set_user, only: [:index, :show]

    def upload_image
        e = Entry.new do |entry|
          entry.user = @user
          entry.picture = user_params[:picture]
        end
        e.save!
        
        @entry = e
    end

    def show

    end

    private
        def user_params
          params.permit(:picture, :user_id)
        end

        def set_user
            up = user_params
            @user = User.find(up[:user_id])
        end
end
