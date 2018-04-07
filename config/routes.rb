Rails.application.routes.draw do
  resource :image, only: :show

  root 'images#show'
end
