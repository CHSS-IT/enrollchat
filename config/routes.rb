Rails.application.routes.draw do
  resources :reports
  get 'static_pages/home'

  devise_for :users, :path_prefix => 'app'
  resources :users
  resources :sections, only: [:index, :show] do
    resources :comments
  end
  post '/sections/import' => 'sections#import'

  mount ActionCable.server, at: '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm
  root to: 'static_pages#home'


end
