Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "/image/:user_id", :to => "custom_image_upload#index"
  get "/image/:user_id", :to =>  "custom_image_upload#show"
end
