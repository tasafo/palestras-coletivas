Palestrascoletivas::Application.routes.draw do
  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"
  get "/ranking", :to => "ranking#index"

  resources :users, only: [:show, :edit, :update]

  resources :talks, except: :destroy do
    get :watch
    get :unwatch
  end

  resource :talks, only: :none do
    post :info_url, path: "info-url"
  end

  resource :talks, only: :none, path: "external_events/:talk_id" do
    resources :external_events, only: [:new, :create, :edit, :update], path: "/"
  end

  resource :talks, only: :none, path: "attach_events/:talk_id" do
    resources :attach_events, only: [:new, :create], path: "/"
  end

  resources :groups, except: :destroy
  resource :groups, only: :none do
    post :info_url, path: "info-url"
  end

  resources :events, except: :destroy
  resource :event, only: :none do
    put :presence
  end

  scope "/ratings/:rateable_type/:rateable_id" do
    post "/ratings", :to => "ratings#create", :as => :ratings
  end

  scope "/comments/:commentable_type/:commentable_id" do
    post   "/comments",     :to => "comments#create",  :as => :comments
    delete "/comments/:id", :to => "comments#destroy", :as => :comment
  end

  get "/schedules/:event_id/new", :to => "schedules#new", :as => :new_schedule
  get "/schedules/:event_id/:id/edit", :to => "schedules#edit", :as => :edit_schedule
  post "/schedules/:event_id/new", :to => "schedules#create", :as => false
  put "/schedules/:event_id/:id/edit", :to => "schedules#update", :as => false
  get "/schedules/search-talks/:search", :to => "schedules#search_talks"
  get "/schedules/:event_id/:id/add_vote", :to => "schedules#add_vote", :as => :add_vote_schedule
  get "/schedules/:event_id/:id/remove_vote", :to => "schedules#remove_vote", :as => :remove_vote_schedule

  post "/activities/get-type" => "activities#get_type"

  get "/enrollments/:event_id/new", :to => "enrollments#new", :as => :new_enrollment
  get "/enrollments/:event_id/:id/:option/edit", :to => "enrollments#edit", :as => :edit_enrollment
  post "/enrollments/:event_id/new", :to => "enrollments#create", :as => false
  put "/enrollments/:event_id/:id/:option/edit", :to => "enrollments#update", :as => false

  resources :password_resets
end
