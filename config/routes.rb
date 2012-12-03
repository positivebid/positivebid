Positive::Application.routes.draw do


  def photo_sizes
    member do
      get 'xs'
      get 'p20'
      get 's'
      get 'p40'
      get 'm'
      get 'p80'
      get 'l'
      get 'p100'
      get 'p160'
      get 'p200'
      get 'xl'
      get 'p320'
      get 'p400'
      get 'xxl'
      get 'p640'
      get 'o' # original
    end
  end

  resources :pictures, only: [:show] do
    photo_sizes
  end

  match '/app' => 'root#app', :as => :app
  match '/minute' => 'root#minute', :as => :minute


  root :to => 'root#index'
  match '/about' => 'root#about', :as => :about
  match '/demo' => 'root#demo', :as => :demo
  match '/return' => 'root#justgiving_return', :as => :return
  match '/frameset' => 'root#frameset', :as => :frameset
  match '/frameset3' => 'root#frameset3', :as => :frameset3


  #omni auth
  match '/auth/:provider/callback', to: 'user_sessions#callback', as: :callback
  match "/auth/failure", to: "user_sessions#failure", as: :failure

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
        collection do
          put :order
        end
        resources :items do
          collection do
            put :order
          end
        end
      end
    end

  end

  # public blog
  resource :blog do
    resources :posts, :controller => 'published_posts', :only => [:show, :index]
  end

  resource :public, :only => [] do
    resources :published_faqs , :only => [:show, :index ] do
      resources :publshed_questions, :only => [:show, :index]
    end
  end

  # admin routes
  resources :posts do
    collection do
      put :preview
    end
  end


  resource :admin_public, :only => [] do
    resources :faqs do
      resources :questions do
        collection do
          put 'order'
        end
      end
    end
  end

  resources :admin_users do
    collection do
      get :report
    end
  end

  resources :admin_auctions do
    resources :admin_lots do
      resources :admin_items
      resources :admin_bids
    end
  end
  resources :admin_lots, :only => [:index]
  resources :admin_items, :only => [:index]
  resources :admin_bids, :only => [:index]


end
