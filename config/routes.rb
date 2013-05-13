Palestrascoletivas::Application.routes.draw do
  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/users/:id", :to => "users#show", :as => :user
  get "/users/:id/edit", :to => "users#edit", :as => :edit_user
  put "/users/:id/edit", :to => "users#update", :as => false

  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"

  resources :talks, except: :destroy do
    get :watch
    get :unwatch
  end

  resource :talks, only: [:none] do
    post :info_url, path: "info-url"
  end


  get "/groups", :to => "groups#index"
  get "/groups/new", :to => "groups#new", :as => :new_group
  get "/groups/:id/edit", :to => "groups#edit", :as => :edit_group
  post "/groups/new", :to => "groups#create", :as => false
  put "/groups/:id/edit", :to => "groups#update", :as => false
  get "/groups/:id", :to => "groups#show", :as => :group
  post "/groups/info-url" => "groups#info_url"

  get "/events", :to => "events#index"
  get "/events/new", :to => "events#new", :as => :new_event
  get "/events/:id/edit", :to => "events#edit", :as => :edit_event
  post "/events/new", :to => "events#create", :as => false
  put "/events/:id/edit", :to => "events#update", :as => false
  get "/events/:id", :to => "events#show", :as => :event

  get "/schedules/:event_id/new", :to => "schedules#new", :as => :new_schedule
  get "/schedules/:event_id/:id/edit", :to => "schedules#edit", :as => :edit_schedule
  post "/schedules/:event_id/new", :to => "schedules#create", :as => false
  put "/schedules/:event_id/:id/edit", :to => "schedules#update", :as => false
  get "/schedules/search-talks/:search", :to => "schedules#search_talks"

  post "/activities/get-type" => "activities#get_type"

  get "/enrollments/:event_id/new", :to => "enrollments#new", :as => :new_enrollment
  get "/enrollments/:event_id/:id/:option/edit", :to => "enrollments#edit", :as => :edit_enrollment
  post "/enrollments/:event_id/new", :to => "enrollments#create", :as => false
  put "/enrollments/:event_id/:id/:option/edit", :to => "enrollments#update", :as => false

  resources :password_resets
end
