Rails.application.routes.draw do
  devise_for :accounts

  root to: 'welcome#index'
  get 'welcome/index'
  get 'welcome/profile'

  get 'autologin' => 'welcome#autologin', as: :autologin
  put 'accounts/change_role' => "accounts#change_role", as: :account_change_role

  resources :accounts, only: [:edit, :update]

  resources  :pages do
    collection do
      get :my
      get :manage
    end
  end
end
