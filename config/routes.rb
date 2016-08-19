Rails.application.routes.draw do
  
  get 'pages/home'
  get 'pages/about'

  resources :attachments
  resources :tenants do
    resources :projects do 
      get 'users', on: :member
      delete 'delete_user'
      put 'add_user', on: :member
    end
  end
  
  resources :members
  root :to => "pages#home"

  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
    match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
    match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan
  end

  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :confirmations => "confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }
  
end
