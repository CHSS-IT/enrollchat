Rails.application.routes.draw do
  devise_for :users
  resources :sections, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm
  root to: 'sections#index'

end
