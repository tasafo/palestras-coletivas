Palestrascoletivas::Application.routes.draw do
  root :to => "talks#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/users/:id", :to => "users#show", :as => :user

  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"

  get "/talks/new", :to => "talks#new", :as => :new_talk
  post "/talks/new", :to => "talks#create", :as => false
  get "/talks/:id", :to => "talks#show", :as => :talk
  post "/talks/get-info-url" => "talks#get_info_url"
end
