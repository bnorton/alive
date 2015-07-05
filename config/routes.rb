Rails.application.routes.draw do
  get 'sign-up' => 'users#new'
  resources :users, :only => [:create]

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:create]
  resources :dashboard, :only => [:index]
  resources :tests, :only => [:index, :show, :edit, :update]
  resources :checks, :only => [:edit, :update]

end
