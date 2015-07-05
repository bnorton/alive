Rails.application.routes.draw do
  get 'sign-up' => 'users#new'
  resources :users, :only => [:create]

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:create]
  resources :dashboard, :only => [:index]
  resources :checks, :only => [:edit, :update]

  resources :tests, :only => [:index, :show, :edit, :update] do
    resources :checks, :only => [:new, :create]
  end

end
