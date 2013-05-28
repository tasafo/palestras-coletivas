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

  get "/talks", :to => "talks#index"
  get "/talks/new", :to => "talks#new", :as => :new_talk
  get "/talks/:id/edit", :to => "talks#edit", :as => :edit_talk
  post "/talks/new", :to => "talks#create", :as => false
  put "/talks/:id/edit", :to => "talks#update", :as => false
  get "/talks/:id", :to => "talks#show", :as => :talk
  post "/talks/info-url" => "talks#info_url"
  get "/talks/:id/watch", :to => "talks#watch", :as => :watch_talk
  get "/talks/:id/unwatch", :to => "talks#unwatch", :as => :unwatch_talk


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
  put "/events/presence", to: "events#presence", as: :event_presence

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

  get "/external_events/:talk_id/new", :to => "external_events#new", :as => :new_external_event
  get "/external_events/:talk_id/:id/edit", :to => "external_events#edit", :as => :edit_external_event
  post "/external_events/:talk_id/new", :to => "external_events#create", :as => false
  put "/external_events/:talk_id/:id/edit", :to => "external_events#update", :as => false

  resources :password_resets
end
