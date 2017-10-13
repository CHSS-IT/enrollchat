Rails.application.routes.draw do
  devise_for :users
  resources :sections, only: [:index, :show] do
    resources :comments
  end
  post '/sections/import' => 'sections#import'

  mount ActionCable.server, at: '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm
  root to: 'sections#index'


end
