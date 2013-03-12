Palestrascoletivas::Application.routes.draw do
  root :to => "home#index"

  get "/signup", :to => "signup#new"
  post "/signup", :to => "signup#create"

  get "/login", :to => "login#new"
end
