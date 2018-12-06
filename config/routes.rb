Rails.application.routes.draw do
  resources :settings, only: [:index, :edit, :update]
  resources :reports
  get 'static_pages/home'
  get 'delete_term/:term', to: 'sections#delete_term'

  devise_for :users, :path_prefix => 'app'
  resources :users do
    member do
      post 'checked_activities'
      get 'archive'
    end
  end
  resources :sections, only: [:index, :show] do
    member do
      patch 'toggle_resolved_section'
    end
    resources :comments
  end

  mount ActionCable.server, at: '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm

  authenticated :user do
    root 'sections#index', as: :authenticated_root
  end

  root to: 'static_pages#home'

end
