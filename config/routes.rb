Palestrascoletivas::Application.routes.draw do
  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"
  get "/ranking", :to => "ranking#index"

  resources :password_resets
  
  resources :users, only: [:show, :edit, :update]

  resources :talks, except: :destroy do
    get :watch
    get :unwatch
    resources :external_events, only: [:new, :create, :edit, :update]
    resources :submit_events, only: [:new, :create]
  end

  resources :events, except: :destroy do
    resources :schedules, only: [:new, :create, :edit, :update] do
      resources :votes, only: [:new, :create]
    end
    resources :enrollments, only: [:new, :create, :edit, :update], path: ":option"
  end

  resource :talks do
    post :info_url
  end

  resource :event do
    put :presence
  end

  scope "/ratings/:rateable_type/:rateable_id" do
    post "/ratings", :to => "ratings#create", :as => :ratings
  end

  scope "/comments/:commentable_type/:commentable_id" do
    post   "/comments",     :to => "comments#create",  :as => :comments
    delete "/comments/:id", :to => "comments#destroy", :as => :comment
  end

  get "/schedules/search-talks/:search", :to => "schedules#search_talks"

  post "/activities/get-type" => "activities#get_type"
end
