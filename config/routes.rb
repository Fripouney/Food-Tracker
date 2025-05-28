Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :fridges
  resources :recipes
  post "recipes/:recipe_id/cook", to: "recipes#cook"
  resources :shopping_lists
  post "shopping_lists/:shopping_list_id/done", to: "shopping_lists#mark_as_done"

  root to: "fridges#index"
  # Defines the root path route ("/")
  # root "posts#index"
end
