require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"
  get "/ranking", :to => "ranking#index"

  resources :password_resets

  resources :users, only: [:index, :show, :edit, :update]

  resources :talks, except: :destroy do
    get :watch
    get :unwatch
    resources :external_events, only: [:new, :create, :edit, :update]
    resources :submit_events, only: [:new, :create]
  end

  resources :events, except: :destroy do
    resources :schedules, only: [:new, :create, :edit, :update, :destroy] do
      resources :votes, only: [:create, :destroy]
      resource :was_presented, only: [:create]
    end
    resources :enrollments, only: [:new, :create, :edit, :update], path: ":option_type"
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

  resources :activities, only: [:create]

  scope '/event_certificates/' do
    get ':id/speakers',                    to: 'event_certificates#speakers',      as: :certificates_speakers
    get ':id/organizers',                  to: 'event_certificates#organizers',    as: :certificates_organizers
    get ':id/participants/:kind/:user_id', to: 'event_certificates#participants',  as: :certificates_participants
  end

  mount Sidekiq::Web, at: "/sidekiq"
end
