Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "upload_image", :to => "custom_image_upload#upload_image"


  get "user/:user_id", :to =>  "user#show"
  post "user/new", :to => "user#new"
end
