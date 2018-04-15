Rails.application.routes.draw do
  resource :image, only: :show
  resource :card, only: :show, path: 'thanks'

  root 'images#show'
end
