Positive::Application.routes.draw do

  match '/app' => 'root#app', :as => :app

  root :to => 'root#index'


  resources :password_resets, :only => [:new, :create, :edit, :update]
  match '/login' => 'user_sessions#new', :as => :login
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/signup' => 'users#new', :as => :register
  match '/signup' => 'users#new', :as => :signup
  match '/activate/:id' => 'users#activate', :as => :activate
  #match '/confirm_email/:id' => 'users#confirm_email', :as => :confirm_email
  match '/resend_activation' => 'users#resend_activation', :as => :resend_activation_link
  resources :user_sessions, only: [:new, :create, :delete] do
    member do
      get :switch
    end
  end

  resource :bids, :controller => :bidding, :only => [:create ]

  resources :users
  resource :home, :controller => :home do

    resources :auctions do
      resources :lots do
        resources :items
      end
    end

  end

end
