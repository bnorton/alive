Rails.application.routes.draw do
  get 'sign-up' => 'users#new'
  resources :users, :only => [:create]

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:create]

  get 'dashboard' => 'dashboards#index'

end
