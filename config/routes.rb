Rails.application.routes.draw do
  resources :sections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htm
  root to: 'sections#index'

end
