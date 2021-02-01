Rails.application.routes.draw do
  resources :orders
  resources :recipients
  resources :schools
  # post 'orders_ship/:id', to: 'orders#orders_ship'
  post "orders/:id/ship" => "orders#orders_ship"
  post "orders/:id/cancell" => "orders#orders_cancel"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
