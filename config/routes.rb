Rails.application.routes.draw do
	root "posts#index"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update] do
    resources :friendships, only: [:create, :destroy] do
      collection do 
        post :approve
        post :ignore
        post :unignore
      end
    end
	  member do
	  	get :post
      get :collect
      get :comment
      get :draft
      get :friend
      post :collect_dislike
    end
  end
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
    member do
      post :like
      post :unlike
    end
  end
	get "/feeds", to: "feeds#index"
  namespace :admin do
    resources :posts, only: [:index, :destroy]
    resources :categories, except: [:show]
    resources :users, except: [:show] do
      post :auth
      post :unauth
    end
    root "posts#index"
  end
end
