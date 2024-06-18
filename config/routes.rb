Rails.application.routes.draw do

      resources :posts, only: [:create, :index, :show] do
      resources :reviews, only: [:create]
    end
  
    get 'top_posts', to: 'posts#top_posts'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html