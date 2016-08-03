Rails.application.routes.draw do
  
  resources :attachments
  resources :tenants do
    resources :projects
  end
  
  resources :members
  root :to => "pages#home"

    
  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :confirmations => "confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }

  get 'pages/home'
  get 'pages/about'
  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
  
end
