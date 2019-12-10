Rails.application.routes.draw do
  resources :settings, only: [:index, :edit, :update]
  resources :reports
  get 'home', to: 'static_pages#home'
  get 'unregistered', to: 'static_pages#unregistered'
  get 'delete_term/:term', to: 'sections#delete_term'

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

  root to: 'static_pages#home'

  get '/login', to: 'sections#index'

  get 'exit', to: 'sessions#end_session', as: :logout
end
