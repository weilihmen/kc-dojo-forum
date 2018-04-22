Rails.application.routes.draw do
	root "posts#index"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show] do
	  member do
	  	get :post
      get :collect
      get :comment
      get :draft
      get :friend
    end
  end
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
	get "/feeds", to: "feeds#index"
end
