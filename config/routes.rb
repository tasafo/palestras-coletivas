Palestrascoletivas::Application.routes.draw do
  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/users/:id", :to => "users#show", :as => :user
  get "/users/:id/edit", :to => "users#edit", :as => :edit_user
  put "/users/:id/edit", :to => "users#update", :as => false
  get "/users/:id/change_password", :to => "users#change_password", :as => :change_password

  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"

  get "/talks", :to => "talks#index"
  get "/talks/new", :to => "talks#new", :as => :new_talk
  get "/talks/:id/edit", :to => "talks#edit", :as => :edit_talk
  post "/talks/new", :to => "talks#create", :as => false
  put "/talks/:id/edit", :to => "talks#update", :as => false
  get "/talks/:id", :to => "talks#show", :as => :talk
  post "/talks/info-url" => "talks#info_url"

  get "/groups", :to => "groups#index"
  get "/groups/new", :to => "groups#new", :as => :new_group
  get "/groups/:id/edit", :to => "groups#edit", :as => :edit_group
  post "/groups/new", :to => "groups#create", :as => false
  put "/groups/:id/edit", :to => "groups#update", :as => false
  get "/groups/:id", :to => "groups#show", :as => :group
  post "/groups/info-url" => "groups#info_url"  
end
