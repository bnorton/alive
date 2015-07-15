Rails.application.routes.draw do
  get 'sign-up' => 'users#new'
  get 'settings' => 'users#show'
  resources :users, :only => [:create, :update]

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:create]
  resources :dashboard, :only => [:index]
  resources :checks, :only => [:edit, :update]

  resources :tests, :only => [:index, :new, :create, :show, :edit, :update] do
    resources :checks, :only => [:new, :create]
    resources :test_runs, :only => [:create]
  end

end
