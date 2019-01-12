class ImageUploadControllerController < ApplicationController
    def index
        p = message_params()
        u = User.find(p[:user_id])
        u.images.attach(p[:images])
    end
    
    private
        def message_params
          params.require(:user_id).permit(images: [])
        end
end
