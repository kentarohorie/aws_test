Rails.application.routes.draw do
  resources :items
  root "items#root"
  get "secret" => "items#secret"
  get "calc" => "items#calc"
  get "stocker" => "items#stocker"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
